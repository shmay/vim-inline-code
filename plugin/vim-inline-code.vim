command! -range -nargs=0 InlineCode :call s:opfunc()
command! -range -nargs=0 InlineCodeWithSeparator :call s:separatorfunc()

" function jacked from
" http://stackoverflow.com/a/6271254/548170
function! s:Get_visual_selection()
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  let lines = getline(lnum1, lnum2)
  let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][col1 - 1:]
  return join(lines, "\n")
endfunction

function! s:WriteToNewBuffer(file_name)
  execute 'rightbelow vsplit ' . a:file_name
  execute 'setlocal filetype=' . &filetype
  execute 'setlocal buftype=nowrite'
endfunction

function! s:Last_line_is_selected()
  let s:lnum = getpos("'>")[1]
  return s:lnum == (line("$") + 1)
endfunction

function! s:Strip(input_string)
    return substitute(a:input_string, '^\s*\(.\{-}\)\n\s*$', '\1', '')
endfunction

function! s:separatorfunc()
  call s:opfunc("yes")
endfunction

function! s:opfunc(with_separator)
  echom 'with_separator: ' . a:with_separator

  let s:Fn = function("s:Get_visual_selection")
  let s:selection = call(s:Fn, [])

  let file_suffix = fnamemodify(bufname("%"), ":e")

  ""echom 'file_suffix: ' . file_suffix
  ""echom 'file_type: ' . &filetype

  """ check if html2haml is in current path
  """ if not, check for rbenv then do some crap to get rbenv loaded
  ""echom 'Usage: ' . match(s:html2haml, 'Usage')

  let file_path = '/tmp/file.' . file_suffix

  " clear file's contents
  " system("> " . file_path)

  call s:WriteToNewBuffer("inlined_code")

  if a:with_separator == "yes"
    let inlined_code = substitute(s:selection, '\n', ';', 'g')
  else
    let inlined_code = substitute(s:selection, '\n', ' ', 'g')
  endif

  " remove multiple spaces
  let inlined_code = substitute(inlined_code, '  \+', ' ', 'g')
  "normal gvx
  let @x = s:Strip(inlined_code)

  if s:Last_line_is_selected()
    normal "xp0yy
  else
    normal "xP0yy
  endif

  "echom v:count
  "silent! call repeat#set("\<Plug>Vhtml_to_haml()")
endfunction
