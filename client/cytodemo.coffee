cytoscape = require 'cytoscape'

emit = ($item, item) ->
  $cy = $ '<div style="width: 400px; height: 400px;"></div>'

  $item.append $cy

  cy = cytoscape {
    container: $cy,

    elements: [
      {} # 1 node
    ]
  }


bind = ($item, item) ->
  $item.dblclick -> wiki.textEditor $item, item

window.plugins.cytodemo = {emit, bind} if window?
module.exports = {} if module?
