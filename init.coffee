# Your init script
#
# Atom will evaluate this file each time a new window is opened. It is run
# after packages are loaded/activated and after the previous editor state
# has been restored.
#
# atom.workspace.observeTextEditors (editor) ->
#   editor.onDidSave ->
#     console.log "Saved! #{editor.getPath()}"

atom.workspace.observeTextEditors (editor) ->
  # editor.onDidSave ->
  #   console.log "Saved! #{editor.getPath()}"
  if editor.getTitle() isnt 'untitled'
    filepath = editor.getPath().split('/')
    title = filepath.slice(filepath.length-3) # gives name of containing folder along with filename
    if title[0] == 'schools_experience' || title[0] == 'teaching_path_creator'
      title = title.slice(1).join('/')
    else
      title = title.join('/')
    editor.getTitle = -> title
    editor.getLongTitle = -> title

for item in atom.workspace.getPaneItems()
  if item.emitter?
    item.emitter.emit 'did-change-title', item.getTitle()

directoryPath = atom.project.rootDirectories[0].path
dirs = directoryPath.split('/')
if /schools_experience|schools_experience_jp|ems_enterprise|teaching_path_creator/.test(directoryPath) 
  parentRepo = dirs[dirs.length - 2]
  submodule = dirs[dirs.length - 1]
else if /sites|sites_jp|[\.]com|cn/.test(directoryPath)
  parentRepo = dirs[dirs.length - 1]
leftPanelTitle = document.getElementsByClassName('title')[0]
# leftPanelTitle = atom.workspace.getLeftDock().innerElement.children[0].children[0].children[1].children[0].children[0].children[0].children[0]
if submodule?
  leftPanelTitle.innerHTML = parentRepo
  submoduleHTMLTag = document.createElement('span')
  submoduleHTMLTag.appendChild(document.createTextNode(' > ' + submodule))
  leftPanelTitle.appendChild(submoduleHTMLTag)
else
  leftPanelTitle.innerHTML = parentRepo
