This is just a very naive implementation of
nohtml idea. We gonna use jquery and rerender whole document as is:

The main functoion `render` accept document as json object and rerender whole body:

    render = (doc)->
      $('body').html('')
      $('body').append(renderRecur(path = [], doc))

We call main ondocument loaded and render, then attach to body events:

    $ ->
      doc = main
      render(doc)
      $('body').on 'click',(e)-> dispatch('click',e)
      $('body').on 'input',(e)-> dispatch('input',e)
      $('body').on 'keyup',(e)-> dispatch('keyup',e)

While dispatch we get the target element and find object
in json document, then calling handler with obj, path, document:

    dispatch = (tp, e)->
      trg = e.target
      pth = trg.id.split '-'
      model = getp doc, pth
      if model
        if tp == 'click' && model.onclick
          model.onclick(model, pth, doc)
          render doc
        if tp == 'input' && model.oninput
          if model.oninput.filter && model.oninput.filter.indexOf e.which > -1
            model.oninput.fn(model, pth,doc)
            render doc
        if tp == 'keyup' && model.onkeyup
          if model.onkeyup.filter && model.onkeyup.filter.indexOf e.which > -1
            model.onkeyup.fn(model, pth,doc)
            render(doc)
            $('#' + pth.join '-').focus()


The renderRecur walk json document and render
every object as div or use value of _tag attribute:


    renderRecur = (path, v) ->
      node = $("<#{v._tag || 'div'}>", id: path.join('-'), class: path[path.length-1])
      if typeof v == 'object'
        if v._text
          node.text(v._text)
        else
          for k in v when k.indexOf('_') != 0
              node.append(
                  renderRecur(
                    conj(path, k), v[k]))
      else
        node.text(JSON.stringify(v))

      if v && v._css
        node.css(v._css)

      if v && v._tag == 'input'
        node.val(v._value)
        node.on 'input', (e)-> v._value = node.val()
      node


Here small set of util functions:

    conj = (coll,x)-> coll.concat([x])

    cnt = 1
    nextId = ()-> cnt++

    getIn = (doc, path)->
      idx=-1
      val = doc
      while idx++ < path.length && val
        val = val[path[idx]]
      val

    dissoc = (doc, path)->
      idx=-1
      val = doc
      while idx++ < (path.length - 1) && val
        val = val[path[idx]]
        if val
          delete val[path[path.length - 1]]
      doc

