## nohtml

Imagine there are no html and css,
only javascript.


This project is naive demonstration of  how it could be.

We start just by requiring index.html and styles:

    require('file?name=index.html!../index.html')
    require('../less/app.less')
    main = require('./lib.litcoffee')


We start from some handlers, which will be used in document.
When event is raised, engine lookup attribute with name of
event type (i.e. onclick) and if it found it callback function
assigned to this attribute passing clicked item, path to it in document
and document itself.

rmTodo - just remove parent object from doc and decrement counter:

    rmTodo = (item, path, doc)->
      dissoc(doc, butlast(path))
      doc.footer.count--
      doc

addTodo - generate uniq id and assoc to todos object

    addTodo = (doc, txt)->
      id = nextId()
      doc.todos[id] =
        title: {_text: txt}
        removeBtn: {_text: 'Remove', onclick: rmTodo}
      doc.footer.count++
      doc.header.newTodo._value = ''
      doc

The application is started as function main, which build
document json and return it:

    doc =
      header:
        btn: {_text: "GOTO", onclick: (()-> doc2)}
        newTodo:
          _tag: 'input'
          onkeyup:
            filter: [13]
            fn: (item, path, doc)->
              txt = item._value
              addTodo(doc, txt) if txt
              doc
      todos: {}
      footer:
        count: 0

     doc2 =
       header:
         title: {_text: 'Window 2'}
         btn: {_text: "GETBACK", onclick: (()-> doc)}
       products:
         sicp: {type: 'Book', title: 'SICP', price: '0'}
         ddd:  {type: 'Book', title: 'DDD', price: '100$'}
         cheh:  {type: 'Book', title: 'Anna Karenina', price: '1$'}


    main ()->
      addTodo(doc, 'Milk')
      addTodo(doc, 'Water')
      doc

Some used helper functions

    cnt = 1
    nextId = ()-> cnt++

    butlast = (a)->
      a && a[0..-2]

    window.butlast = butlast

    dissoc = (doc, path)->
      idx=-1
      val = doc
      while idx++ < (path.length - 1) && val
        val = val[path[idx]]
        if val
          delete val[path[path.length - 1]]
      doc
