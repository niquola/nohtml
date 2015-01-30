## nohtml

Imagine there are no html and css,
only javascript.


This project is naive demonstration of  how it could be.

We start just by requiring index.html and styles:

    require('file?name=index.html!../index.html')
    require('../less/app.less')
    require('./lib.litcoffee')


We start from some handlers, which will be used in document.
When event is raised, engine lookup attribute with name of
event type (i.e. onclick) and if it found it callback function
assigned to this attribute passing clicked item, path to it in document
and document itself.

rmTodo - just remove parent object from doc and decrement counter:

    rmTodo = (item, path, doc)->
      dissoc(doc, butlast(path))
      doc.footer.count--

addTodo - generate uniq id and assoc to todos object

    addTodo = (doc, txt)->
      id = nextId()
      doc.todos[id] =
        title: {_text, txt}
        removeBtn: {_text: 'Remove', onclick: rmTodo}
      doc.footer.count++
      doc.header.newTodo._value = ''

The application is started as function main, which build
document json and return it:

    doc =
      header:
        newTodo:
          _tag: 'input'
          _value: 'todo it'
          onkeyup:
            filter: [13]
            fn: (item, path, doc)->
              txt = item._value
              addTodo(doc, txt) if txt
      todos: {}
      footer:
        count: 0


    main = ()->
      addTodo(doc, 'Milk')
      addTodo(doc, 'Water')
      doc
