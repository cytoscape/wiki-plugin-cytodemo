cytoscape = require 'cytoscape'
dagre = require 'dagre'
cydagre = require 'cytoscape-dagre' # dagre ext for cytoscape (https://github.com/cytoscape/cytoscape.js-dagre)

cydagre cytoscape, dagre

# from wiki-plugin-transport
graphData = ($item) ->
  graphs = []
  candidates = $(".item:lt(#{$('.item').index($item)})")
  for each in candidates
    if $(each).hasClass 'graph-source'
      graphs.push each.graphData()
  graphs

# from image-transporter
# def merge (graphs)
#   graph = Hash.new { |hash, key| hash[key] = [] }
#   graphs.each do | obj |
#     obj.each do | from, tos |
#       have = graph[from]
#       graph[from] = [have, tos].flatten.uniq
#     end
#   end
#   graph
# end

merge = (graphs) ->
  graph = {}
  for obj in graphs
    for from, tos of obj
      have = graph[from] ||= []
      for to in tos
        have.push to if to not in have
  graph

elements = ($item, item) ->
  return JSON.parse item.text if /\w/.test item.text
  nodes = {}
  edges = {}
  graph = merge graphData $item
  for from, tos of graph
    nodes[from] = true
    for to in tos
      nodes[to] = true
      edges["#{from}|||#{to}"] = true
  dataEdge = (edge) -> {data: {source: edge[0], target:edge[1]}}
  dataEdges = -> (dataEdge e.split '|||' for e,v of edges)
  dataNodes = -> ({data: {id: n}} for n,v of nodes)
  {nodes: dataNodes(), edges: dataEdges()}

block = (event) ->
  event.preventDefault()
  event.stopPropagation()

emit = ($item, item) ->
  $cy = $ '<div class="cytowiki" style="position: relative; width: 420px; height: 420px; border: 1px solid #ccc;"></div>'
  $item.append $cy

  #
  $caption = $ '<p></p>'
  $caption.append 'Learn more about <a href="http://js.cytoscape.org">Cytoscape</a>.'
  $fullscreenlink =  $ '<span> - <a id="cy-fullscreen" href="#">Full Screen</a>.</span>'
  $caption.append $fullscreenlink
  $item.append $caption

  $cy.on 'mousedown', block
  $cy.on 'tapped', block

  options = {
    layout: { name: 'dagre' },
    boxSelectionEnabled: false,
    autounselectify: true,
    style: [
      {
        selector: 'node',
        style: {
          'content': 'data(id)',
          'text-opacity': 0.5,
          'text-valign': 'center',
          'text-halign': 'right',
          'background-color': '#11479e',
          'width' : (d) ->
            if d.degree() == 1 then 8 else d.degree()*5
          'height' : (d) ->
            if d.degree() == 1 then 8 else d.degree()*5
        }
      },
      {
        selector: 'edge',
        style: {
          'width': 2 ,
          'target-arrow-shape': 'triangle',
          'line-color' : '#9dbaea',
          'line-opacity': .7,
          'target-arrow-color': '#9dbaea'
        }
      }
    ]
    elements: elements($item,item)
  }

  options.container = $cy
  cy = cytoscape options

  cy.on 'click', 'node', (e) ->
    node = e.cyTarget;
    page = $item.parents '.page' unless e.shiftKey
    wiki.doInternalLink node.id(), page

  cy.on 'mouseover', 'node', (e) ->
        e.cyTarget.style {
          'border-width': 2,
          'border-color': '#D84315',
          'font-size' : (d) ->
            size = Number(d.css("font-size").slice(0, -2))+10
            size + "px"
        }

  cy.on 'mouseout', 'node',(e) ->
        e.cyTarget.style {
          'border-width': 0,
          'font-size' : (d) ->
            size = Number(d.css("font-size").slice(0, -2))-10
            size + "px"
        }

  # create a lightbox to display fullscreen
  $lightbox = $ '<div id="lightbox"></div>'
  $lightbox.css {
    "width" :"100%",
    "height" : "100%",
    "position": "fixed",
    "background-color": "rgba(0,0,0,.7)",
    "top": 0,
    "right": 0,
    "bottom": 0,
    "left": 0,
    }

  # options
  $close = $ '<a href="#" style="position : absolute; color : #FAFAFA; top : 50px; right : 50px">X</a>'
  $close.on 'click', (e) ->
    $lightbox.hide()
    $cyfullscreen.find("canvas").remove() # delete graph instances

  $lightbox.append $close
  $lightbox.hide() # hide by default

  # prevent adding multiple lightboxes
  $("body").append $lightbox if $(".lightbox").length == 0

  # add a second cytoscape graph to the lightbox
  $cyfullscreen = $ '<div class="cyfullscreen" style="position: relative; width: 80vw; height: 80vh; border: 1px solid #ccc; margin : 4% auto; background-color: #F5F5F5; padding: 10px;"></div>'
  $lightbox.append $cyfullscreen

  $fullscreenlink.on "click", (e) ->
    e.preventDefault()
    options.container = $cyfullscreen
    cyfullscreen = cytoscape options
    console.log cyfullscreen
    $lightbox.show()

bind = ($item, item) ->
  $item.dblclick -> wiki.textEditor $item, item

window.plugins.cytodemo = {emit, bind} if window?
module.exports = {} if module?
