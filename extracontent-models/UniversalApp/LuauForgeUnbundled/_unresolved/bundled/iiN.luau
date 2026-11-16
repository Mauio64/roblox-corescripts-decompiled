local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local SoundService = game:GetService("SoundService")

local module = require("@luauforge/bundled/iiO")
local module2 = require("@luauforge/bundled/iiP")
local module3 = require("@luauforge/bundled/iiV")
local module4 = require("@luauforge/bundled/iiQ")
local module5 = require("@luauforge/bundled/iiU")
local module6 = require("@luauforge/bundled/ijb")

local module7 = require("@luauforge/bundled/iiZ")
local v5 = require("@luauforge/bundled/iiY")()
local v6 = if v5 then module7("ReadAloudManager") else nil

local inputBeganConnection = nil

local v7 = {}

local v8 = nil

local v9 = nil
local v10 = nil

local lastTime = -1

local mouseButton2Set = { [Enum.UserInputType.MouseButton2] = true }

local function shouldInputTriggerTTS(p2): boolean
	if mouseButton2Set[p2.UserInputType] then
		return true
	end

	return false
end

function LUAUFORGE_MODULE_GLOBALS_iiN_TriggerTTS(p2)
	return function(p3, p4)
		if not mouseButton2Set[p3.UserInputType] then
			module6.highlight(p2, v9)
		elseif v9 and v8 then
			if v10 == v9 then
				if v5 then
					v6:debug("Clicked previously read object------------------------")
				end

				if v8.State == module3.Playing then
					v8:Pause()
				elseif v8.State == module3.Idle or v8.State == module3.Paused then
					v8:Play()
				elseif v8.State == module3.Loading then
					v6:info("TTSHandler is loading, blocked input")
				end
			else
				if v5 then
					v6:debug("Clicked new text------------------------")
				end

				lastTime = os.clock()

				v10 = v9
				local descendantText = module4.retrieveDescendantText(v9)

				v8:SetText(descendantText)
				v8:Play()
			end
		end
	end
end

local function connectMouseOver(p2)
	RunService:BindToRenderStep("ReadAloudHighlight", Enum.RenderPriority.Input.Value + 1, function()
		if
			os.clock() - lastTime > module5.ReadAloudLoadCooldown
			and (UserInputService:GetLastInputType() == Enum.UserInputType.MouseMovement or UserInputService:GetLastInputType() == Enum.UserInputType.MouseWheel)
		then
			local v11 = module(UserInputService:GetMouseLocation() - GuiService:GetGuiInset())

			if v11 ~= v9 then
				v9 = v11
			end
		else
			v9 = nil
		end

		module6.highlight(p2, v9)
	end)
end
local function disconnectMouseOver()
	RunService:UnbindFromRenderStep("ReadAloudHighlight")
end

function v7.Enable()
	if v8 then
		v6:warning("Attempted to enable Read Aloud, but it's already enabled!")
		return
	end

	local v11 = module6.setUpHighlight()
	inputBeganConnection = UserInputService.InputBegan:Connect(LUAUFORGE_MODULE_GLOBALS_iiN_TriggerTTS(v11))
	v8 = module2.new()

	SoundService:SetSoundEnabled(true)
	RunService:BindToRenderStep("ReadAloudHighlight", Enum.RenderPriority.Input.Value + 1, function()
		if
			os.clock() - lastTime > module5.ReadAloudLoadCooldown
			and (UserInputService:GetLastInputType() == Enum.UserInputType.MouseMovement or UserInputService:GetLastInputType() == Enum.UserInputType.MouseWheel)
		then
			local v12 = module(UserInputService:GetMouseLocation() - GuiService:GetGuiInset())

			if v12 ~= v9 then
				v9 = v12
			end
		else
			v9 = nil
		end

		module6.highlight(v11, v9)
	end)
end

function v7.Disable()
	if not v8 then
		v6:warning("Attempted to disable Read Aloud, but it's already disabled!")
		return
	end

	if inputBeganConnection then
		inputBeganConnection:Disconnect()
	end

	inputBeganConnection = nil
	v8:CleanUp()
	v8 = nil
	RunService:UnbindFromRenderStep("ReadAloudHighlight")

	module6.cleanUpHighlight()
end

function v7.ReadSystemTextFromKey(p2)
	if not v8 then
		v6:warning("Tried to read text, but Read Aloud is not enabled!")
		return
	end

	if v5 then
		v6:debug(`Requesting system TTS for key "{p2}"`)
	end

	v8:ReadSystemTextFromKey(p2)
end

return v7
