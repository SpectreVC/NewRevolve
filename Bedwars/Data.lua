local Data_Path = "NewRevolve/Saves/Data.lua"

local Data_Check = game:GetService("HttpService"):JSONDecode(readfile(Data_Path))

if Data_Check then
writefile(Data_Path, game:GetService("HttpService"):JSONEncode(false))
  loadfile("NewRevolve/Config/MainSrc.lua")()
end

if not Data_Check then
loadfile("NewRevolve/Config/MainSrc.lua")()
end
