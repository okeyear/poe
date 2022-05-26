`::

{
v_Enable:=!v_Enable
If (v_Enable=0)
{

SetTimer, Label4, Off



}
Else
{

SetTimer, Label4, 3200



}
}
Return






Label4:
{
Send,5
}




return



