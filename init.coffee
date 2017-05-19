# Your init script
#
# Atom will evaluate this file each time a new window is opened. It is run
# after packages are loaded/activated and after the previous editor state
# has been restored.
#
# An example hack to log to the console when each text editor is saved.
#
# atom.workspace.observeTextEditors (editor) ->
#   editor.onDidSave ->
#     console.log "Saved! #{editor.getPath()}"

atom.workspace.observeTextEditors (editor) ->
    if editor.getTitle() isnt 'untitled'
        sp = editor.getPath().split('/')
        if 'js' in sp
          title = sp.slice(sp.indexOf('js')+1).join('/') # gives name of containing folder along with filename
        else
          dirs = sp.filter (s) -> /_com|_cn/.test(s)
          title = sp.slice(sp.indexOf(dirs[0])).join('/') # gives name of containing folder along with filename
        editor.getTitle = -> title
        editor.getLongTitle = -> title

for item in atom.workspace.getPaneItems()
    if item.emitter?
        item.emitter.emit 'did-change-title', item.getTitle()

dirs = atom.project.rootDirectories[0].path.split('/')
parentRepo = dirs[dirs.length - 2]
leftPanelTitle = atom.workspace.getLeftDock().innerElement.children[0].children[0].children[1].children[0].children[0].children[0].children[0]
leftPanelTitle.innerHTML = parentRepo
