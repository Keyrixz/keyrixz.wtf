--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
-- vapour is hot
-- feel free to change aim key, wallcheck, body part etc.
local TeamCheck = true
local WallCheck = true
local Key = "E"
local BodyPart = "Torso"
local FOV = 1000
local Inset = game:GetService("GuiService"):GetGuiInset()
local SC = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)
local Mouse = game:GetService("Players").LocalPlayer:GetMouse()
if string.len(Key) == 1 then
    Key = string.upper(Key)
end
function NotObstructing(Destination, Ignore)
    local Origin = workspace.CurrentCamera.CFrame.Position
    local CheckRay = Ray.new(Origin, Destination - Origin)
    local Hit = workspace:FindPartOnRayWithIgnoreList(CheckRay, Ignore)
    return Hit == nil
end
function ClosestHoe()
    local MaxDist, Nearest = math.huge
    for I,V in pairs(game:GetService("Players"):GetPlayers()) do
        if V ~= game:GetService("Players").LocalPlayer and V.Character and V.Character:FindFirstChild("Humanoid") then
            if WallCheck then
                if TeamCheck then
                    if V.Team ~= game:GetService("Players").LocalPlayer.Team then
                        local Pos, Vis = workspace.CurrentCamera:WorldToScreenPoint(V.Character[BodyPart].Position)
                        if Vis and NotObstructing(V.Character[BodyPart].Position, {game:GetService("Players").LocalPlayer.Character, V.Character}) then
                            local Diff = math.sqrt((Pos.X - SC.X) ^ 2 + (Pos.Y + Inset.Y - SC.Y) ^ 2)
                            if Diff < MaxDist and Diff < FOV then
                                MaxDist = Diff
                                Nearest = V
                            end
                        end
                    end
                else
                    local Pos, Vis = workspace.CurrentCamera:WorldToScreenPoint(V.Character[BodyPart].Position)
                    if Vis and NotObstructing(V.Character[BodyPart].Position, {game:GetService("Players").LocalPlayer.Character, V.Character}) then
                        local Diff = math.sqrt((Pos.X - SC.X) ^ 2 + (Pos.Y + Inset.Y - SC.Y) ^ 2)
                        if Diff < MaxDist and Diff < FOV then
                            MaxDist = Diff
                            Nearest = V
                        end
                    end
                end
            else
                if TeamCheck then
                    if V.Team ~= game:GetService("Players").LocalPlayer.Team then
                        local Pos, Vis = workspace.CurrentCamera:WorldToScreenPoint(V.Character[BodyPart].Position)
                        if Vis then
                            local Diff = math.sqrt((Pos.X - SC.X) ^ 2 + (Pos.Y + Inset.Y - SC.Y) ^ 2)
                            if Diff < MaxDist and Diff < FOV then
                                MaxDist = Diff
                                Nearest = V
                            end
                        end
                    end
                else
                    local Pos, Vis = workspace.CurrentCamera:WorldToScreenPoint(V.Character[BodyPart].Position)
                    if Vis then
                        local Diff = math.sqrt((Pos.X - SC.X) ^ 2 + (Pos.Y + Inset.Y - SC.Y) ^ 2)
                        if Diff < MaxDist and Diff < FOV then
                            MaxDist = Diff
                            Nearest = V
                        end
                    end
                end
            end
        end
    end
    return Nearest
end

game:GetService("RunService").RenderStepped:Connect(function()
    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode[Key]) then
        local Hoe = ClosestHoe()
        if Hoe and Hoe.Character and Hoe.Character:FindFirstChild(BodyPart) then
            local Pos, Vis = workspace.CurrentCamera:WorldToScreenPoint(Hoe.Character[BodyPart].Position)
            if Vis then
                mousemoverel(Pos.X - Mouse.X, Pos.Y - Mouse.Y)
            end
        end
    end
end)
