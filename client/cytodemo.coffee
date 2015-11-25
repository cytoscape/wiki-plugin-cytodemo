cytoscape = require 'cytoscape'
dagre = require 'dagre'
cydagre = require 'cytoscape-dagre' # dagre ext for cytoscape (https://github.com/cytoscape/cytoscape.js-dagre)

cydagre cytoscape dagre # register cy-dagre ext w/ cytoscape

emit = ($item, item) ->
  $cy = $ '<div style="position: relative; width: 420px; height: 420px; border: 1px solid #ccc;"></div>'

  $item.append $cy
  $item.append '<p>Learn more about <a href="http://js.cytoscape.org">Cytoscape</a>.</p>'

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
    elements: JSON.parse item.text
  }


bind = ($item, item) ->
  $item.dblclick -> wiki.textEditor $item, item

window.plugins.cytodemo = {emit, bind} if window?
module.exports = {} if module?
