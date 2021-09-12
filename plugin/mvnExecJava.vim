" https://github.com/mikelue/vim-maven-plugin
" https://github.com/vim-scripts/maven-ide

" variable show existense of this script
let g:has_mvn_exec_java = 1
function! MvnExecJava()
    exec "w"
	let currentBuffer = bufnr("%")
	let packageName = GetJavaPackageOfBuffer(currentBuffer)
	let fileNameWithoutExtension = expand('%:t:r')
    let mainClass = packageName.".".fileNameWithoutExtension

"     if !isBufferUnderMavenProject(currentBuffer)
    "     return
    " endif
"
    " execute "!mvn exec:java -D exec.mainClass=".getJavaPackageOfBuffer(currentBuffer).".".expand('%:t:r')
    " execute "!mvn compile"
    " execute "!mvn exec:java -D exec.mainClass=".mainClass
    execute "term mvn compile exec:java -D exec.mainClass=".mainClass
endfunction

" ==================================================
" Functions for Package Information
" ==================================================
function! GetMavenProjectRoot(buf)
	return getbufvar(a:buf, "_mvn_project")
endfunction

function! ConvertPathToJavaPackage(filename)
    let targetPath = SlashFnamemodify(a:filename, ":p:h")

    let pattern = '\v(^.+/src/[^/]+/\k+/)@<=.+'
    if targetPath !~ pattern
        return targetPath
    endif

    return substitute(matchstr(targetPath, pattern), '/', '.', 'g')
endfunction

function! GetJavaPackageOfBuffer(buf)
"     if !isBufferUnderMavenProject(a:buf)
        " return "<Unknown>"
"     endif

    return substitute(GetJavaClasspathOfBuffer(a:buf), '/', '.', 'g')
endfunction

function! GetJavaClasspathOfBuffer(buf)
  "   if !isBufferUnderMavenProject(a:buf)
        " return "<Unknown>"
  "   endif

	" Remodify the file name in case of different letter case of path
	let projectRoot = SlashFnamemodify(GetMavenProjectRoot(a:buf), ":p:h")
	let dirOfFile = SlashFnamemodify(bufname(a:buf), ":p:h")
	" //:~)

    let resultClasspath = substitute(dirOfFile, projectRoot, '', '')

    let resultClasspath = matchstr(resultClasspath, '\v(^/src/[^/]+/\k+/)@<=.+') " Remove first three heading paths

    return resultClasspath
endfunction
" // Functions for Package Information :~)

" ==================================================
" Miscelllaneous Functions
" ==================================================
function! SlashFnamemodify(fname, mods)
	let fnameResult = fnamemodify(a:fname, a:mods)

	if has("win32") && !&shellslash
		return substitute(fnameResult, '\\\+', '/', 'g')
	endif

	return fnameResult
endfunction
