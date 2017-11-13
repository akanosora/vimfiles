" Default 'meets' function for Python
function acp#python#Meets(context, ...)
  return has('python') && g:acp_python_omni_length >= 0 &&
        \ (a:0 > 0 ? a:context =~ '\k\.\k\{' . a:1 . '}$' : a:context =~ '\k\.\k\{' . g:acp_python_omni_length . ',}$')
endfunction
