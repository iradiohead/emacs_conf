@echo off
IF  "%1" == ""  GOTO GEN_PLM
IF  "%1" == "PLM"    GOTO GEN_PLM
IF  "%1" == "C"      GOTO GEN_C
IF  "%1" == "c"      GOTO GEN_C
GOTO HELP
goto end

:GEN_PLM
::find ./ |egrep -i "\w*\.h$|\w*\.c$|\w*\.sdt$|\w*\.spd$|\w*\.sdl$|\w*\.a$|\w*\.p38$|\w*\.p86$|\w*\.a38$|\w*\.a86$|\w*\.inc$|\w*\.inf$|\w*\.pin$|\w*\.cin$|\w*\.cdt$|\w*\.sli$|\w*\.pli$|\w*\.pva$" |xargs etags --language=auto --regex=@d:\emacs\.emacs.d\regex.all
find ./ |egrep -i "TAGS$" |xargs rm -f
::find ./ |egrep -i "\w*\.p38$|\w*\.p86$|\w*\.pin$|\w*\.pli$|\w*\.pva$|\w*\.inc$" |xargs etags --language=auto --regex=@d:\emacs\.emacs.d\regex_plm.file
find ./ |egrep -i "\w*\.p38$|\w*\.p86$|\w*\.pin$|\w*\.pli$|\w*\.pva$" |xargs etags --language=auto --regex=@d:\emacs\.emacs.d\regex_plm.file
find ./ |egrep -i "\w*\.sdt$|\w*\.spd$|\w*\.sdl$|\w*\.inf$|\w*\.sli$" |xargs etags -a --language=auto --regex=@d:\emacs\.emacs.d\regex_tnsdl.file 
::find ./ |egrep -i "\w*\.asm$|\w*\.a38$|\w*\.a86$|\w*\.inc$" |xargs etags -a --language=asm
find ./ |egrep -i "\w*\.asm$|\w*\.a38$|\w*\.a86$" |xargs etags -a --language=asm
find ./ |egrep -i "\w*\.h$|\w*\.c$|\w*\.cin$|\w*\.cli$|\w*.cva$" |xargs etags -a --language=auto
find ./ |egrep -i "\w*\.inc$" |xargs etags -a
goto end

:GEN_C
find ./ -name "\w*\.[ch]" -or -name "\w*\.sdl" -or -name "\w*\.sdt" -or -name "\w*\.spd" -or -name "\w*\.a*"|xargs etags

goto end

:HELP
echo    PLM for generating PLM related language.
echo    C/c for generating C related language.
:end
