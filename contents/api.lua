local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ApiTime = tick()
local CAPIAR_B = false
local Api = {}
function Api.ExecName() return identifyexecutor and identifyexecutor() or getexecutorname and getexecutorname() or whatexecutor and whatexecutor() end
function Api.ForceExecutorRank() forceit = true; end
function Api:TableFind(what, tbl) for index, value in next, tbl do if string.find(value, what) then return value, index end end end
function Api:TableFind2(what, tbl) for index, value in next, tbl do if string.find(index, what) then return index, value end end end
function Api.IsUnsupported() return Api:TableFind(Api.ExecName():lower(), {"solara", "xeno", "nezur"}) end
function Api.ExeuctorRanking() local ranking = {["CATAPI_FORCE"] = 0x010000000000000000; ["synapse x"] = 69; ["krnl"] = 44; ["nx"] = 5; ["awp"] = 5; ["arceus"] = 4; ["delta"] = 4; ["codex"] = 4; ["vega"] = 3; ["cubix"] = 3; ["macsploit"] = 3; ["celery"] = 3; ["synapse z"] = 3; ["synapsez"] = 3; ["synz"] = 3; ["wave"] = 3; ["swift"] = 3; ["argon"] = 2; ["solara"] = 1; ["xeno"] = 1; ["byte"] = 1; ["nezur"] = -math.huge} if (forceit == true) then return ranking["CATAPI_FORCE"] end local executor = Api.ExecName():lower() local pos = Api:TableFind2(executor, ranking) if (ranking[pos]) then return ranking[pos] else return 0 end end
function Api.Abs(a) Api.Assert(a > 0, "Numebr must be negative!") return math.abs(a) end
function Api.Neg(a) Api.Assert(a < 0, "Numebr must be positive!") return -a end
function Api.Mul(a, b) return a * b end
function Api.Div(a, b) return a / b end
function Api.Add(a, b) return a + b end
function Api.Sub(a, b) return a - b end
function Api.Mod(a, b) return a % b end
function Api.Fdiv(a, b) return a // b end
function Api.Time() return tick() end
function Api.Run(func, ...) do task.spawn(func, ...) end end
function Api.NoFunc() return function() end end
function Api.ModifyAPI(name, newfunc) if (Api[name] ~= nil) then Api[name] = newfunc or Api.NoFunc() end end
function Api.GetName() return LocalPlayer.Name end
function Api.GetID() return LocalPlayer.UserId end
function Api.Exists(part1, part2) if (part1 ~= nil) then for _, object in part1:GetChildren() do if object.Name == tostring(part2) then return object end end end end
function Api.GetCharacter(custom) local Character = (custom and custom.Character) or LocalPlayer.Character if (Character and Api.Exists(Character, "HumanoidRootPart") and Api.Exists(Character, "Humanoid") and Character.Humanoid.Health > 0) then return Character end end
function Api.GetWalkingSpeed(custom) local Character = Api.GetCharacter() return Character and Character:WaitForChild("HumanoidRootPart").Velocity.Magnitude * Vector3.new(1, 0, 1) end
function Api.Assert(statement, error_message) if (statement == true) then error(error_message or "Error!") end end
function Api.Humanoid() local Character = Api.GetCharacter() return Character and Character:WaitForChild("Humanoid") end
function Api.Root() local Character = Api.GetCharacter() return Character and Character:WaitForChild("HumanoidRootPart") end
function Api.Shutdown() game:Shutdown() end
function Api.ApiTime() return ApiTime end
function Api.ApiVersion() return 'API_V1' end
function Api.FindPerson(short) for _, p in next, Players:GetChildren() do if string.find(p.Name, short) then return p elseif string.find(p.DisplayName, short) then return p end end end
function Api:Print(...) for _, msg in ipairs({...}) do warn("[API] : " .. tostring(msg)) end end
function Api:LoadURL(url) return loadstring(game:HttpGet(url))() end
function Api:RunCode(codestring) return loadstring(codestring)() end
function Api:LoadFile(file) if (isfile(file)) then return loadfile and loadfile(file)() or (function() return loadstring(readfile(file)) end)() end end
function Api.Assign(g, new) if (getfenv[tostring(g)]) then getfenv()[tostring(n)] = new end end
function Api.Store(i, v) if (store == nil) then store = {} end store[i] = v end
function Api.ApiRetrieved() if (not CAPIAR_B) then CAPIAR_B = true end return (CAPIAR_B) end
return{GetApi = function()local ApiRetrievedTime = Api.Time()function Api.GetApiRetrievedTime()return ApiRetrievedTime;endwarn("\n\n----------------------\n\tRetrieved Api\n----------------------\n\n")return(Api)end};
