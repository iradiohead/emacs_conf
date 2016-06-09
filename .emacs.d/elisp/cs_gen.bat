@echo off
find ./ |egrep -i "\w*\.p38$|\w*\.p86$|\w*\.pin$|\w*\.pli$|\w*\.pva$|\w*\.sdt$|\w*\.spd$|\w*\.sdl$|\w*\.inf$|\w*\.sli$|\w*\.asm$|\w*\.a38$|\w*\.a86$|\w*\.inc$|\w*\.h$|\w*\.c$|\w*\.cin$|\w*\.cli$|\w*\.cva$" > cscope.files
cscope -CbkR
GOTO HELP
goto end

:HELP
find ./ |egrep -i "\w*\.p38$|\w*\.p86$|\w*\.pin$|\w*\.pli$|\w*\.pva$|\w*\.sdt$|\w*\.spd$|\w*\.sdl$|\w*\.inf$|\w*\.sli$|\w*\.asm$|\w*\.a38$|\w*\.a86$|\w*\.inc$|\w*\.h$|\w*\.c$|\w*\.cin$|\w*\.cli$|\w*\.cva$" > cscope.files
cscope -bkCR
:end
