function! MvnExecJava()
    exec "w"
	let currentBuffer = bufnr("%")
	let packageName = maven#getJavaPackageOfBuffer(currentBuffer)
	let fileNameWithoutExtension = expand('%:t:r')
    let mainClass = packageName.".".fileNameWithoutExtension

    if !maven#isBufferUnderMavenProject(currentBuffer)
        return
    endif

    " execute "!mvn exec:java -D exec.mainClass=".maven#getJavaPackageOfBuffer(currentBuffer).".".expand('%:t:r')
    " execute "!mvn compile"
    " execute "!mvn exec:java -D exec.mainClass=".mainClass
    execute "term mvn compile exec:java -D exec.mainClass=".mainClass
endfunction


