cytoscape = require 'cytoscape'

emit = ($item, item) ->
  $cy = $ '<div style="position: relative; width: 400px; height: 400px; border: 1px solid #ccc;"></div>'

  $item.append $cy
  $item.append '<p>Learn more about <a href="http://js.cytoscape.org">Cytoscape</a>.</p>'

  cy = cytoscape {
    container: $cy,

    layout: { name: 'circle' },

    elements: JSON.parse item.text
  }


bind = ($item, item) ->
  $item.dblclick -> wiki.textEditor $item, item

window.plugins.cytodemo = {emit, bind} if window?
module.exports = {} if module?
