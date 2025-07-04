--Cancel player buff function borrowed from Lazy Pigs

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_AURAS_CHANGED")
local isAntiGriefOn = false -- Default: off

local function SlashCmdHandler(msg)
    if msg == "on" then
        isAntiGriefOn = true
        DEFAULT_CHAT_FRAME:AddMessage("Skoon Protection On", 1, 1, 0)
    elseif msg == "off" then
        isAntiGriefOn = false
        DEFAULT_CHAT_FRAME:AddMessage("Skoon Protection Off", 1, 1, 0)
    else
        DEFAULT_CHAT_FRAME:AddMessage("Usage: /skoons on | off", 1, 1, 0)
    end
end

SLASH_SKOONS1 = "/skoons"
SlashCmdList["SKOONS"] = SlashCmdHandler

local function AntiGrief()
    local buff = {"Spell_Holy_SealOfProtection", "Ability_Rogue_Disguise"}
    local counter = 0
    while GetPlayerBuff(counter) >= 0 do
        local index, untilCancelled = GetPlayerBuff(counter)
        if untilCancelled ~= 1 then
            local texture = GetPlayerBuffTexture(index)
            if texture then 
                local i = 1
                while i <= #buff do
                    if string.find(texture, buff[i]) then
                        CancelPlayerBuff(index);
                        UIErrorsFrame:Clear();
                        UIErrorsFrame:AddMessage("BOP Removed");
                        return
                    end
                    i = i + 1
                end
            end
        end
        counter = counter + 1
    end
    return nil
end

f:SetScript("OnEvent", function()
    if isAntiGriefOn then
        if event == "PLAYER_AURAS_CHANGED" then
            AntiGrief()
        end
    end
end)