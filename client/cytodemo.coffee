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

emit = ($item, item) ->
  $cy = $ '<div style="position: relative; width: 420px; height: 420px; border: 1px solid #ccc;"></div>'
  $item.append $cy
  $item.append '<p>Learn more about <a href="http://js.cytoscape.org">Cytoscape</a>.</p>'
  console.log("ola cytoscape!")
  cy = cytoscape {
    container: $cy,
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
          'background-color': '#11479e'
        }
      },
      {
        selector: 'edge',
        style: {
          'width': 4,
          'target-arrow-shape': 'triangle',
          'line-color': '#9dbaea',
          'target-arrow-color': '#9dbaea'
        }
      }
    ]
    elements: elements($item,item)
  }


  cy.on 'mousedown', (e) ->
      console.log "mousedown graph"

  cy.on 'tapend', (e) ->
      console.log "tapend graph"

  cy.on 'mouseup', (e) ->
      console.log "mouseup graph"

  # mouse actions
  cy.on 'mouseover', 'edge', (e) ->
    edge = e.cyTarget;
    console.log "edge: %s", edge.id()

  cy.on 'mouseover', 'node', (e) ->
    node = e.cyTarget;
    console.log "node: %s",node.id()

  cy.on 'free', 'node', (e) ->
    node = e.cyTarget;
    console.log '%s :I am free !', node.id()

  cy.on 'grab', 'node', (e) ->
    node = e.cyTarget;
    console.log '%s :I am grabbed...', node.id()


bind = ($item, item) ->
  $item.dblclick -> wiki.textEditor $item, item

window.plugins.cytodemo = {emit, bind} if window?
module.exports = {} if module?
