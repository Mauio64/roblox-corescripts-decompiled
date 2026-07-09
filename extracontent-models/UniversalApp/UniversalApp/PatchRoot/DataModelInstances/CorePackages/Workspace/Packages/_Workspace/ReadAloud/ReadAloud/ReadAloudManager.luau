local scriptParent = script.Parent
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local SoundService = game:GetService("SoundService")
local getCoreGuiAtPosition = require(scriptParent.getCoreGuiAtPosition)
local TTSHandler = require(scriptParent.TTSHandler)
local TTSHandlerState = require(scriptParent.TTSHandlerState)
local TextUtility = require(scriptParent.TextUtility)
local Properties = require(scriptParent.Properties)
local highlightCoreGui = require(scriptParent.highlightCoreGui)
local CreateLogger = require(scriptParent.CreateLogger)
local v13 = require(scriptParent.getFFlagReadAloudDebugPrintouts)()
local v14 = if not v13 then nil else CreateLogger(script.Name)
local connection = nil
local t1 = {}
local u17 = nil
local u18 = nil
local u19 = nil
local n1 = -1
local t2 = {
	[Enum.UserInputType.MouseButton2] = true
}

local function shouldInputTriggerTTS(p1) -- line: 58
	-- upvalues: t2 (copy)
	if t2[p1.UserInputType] then
		return true
	end

	return false
end

function TriggerTTS(p2) -- line: 63
	-- upvalues: t2 (copy), highlightCoreGui (copy), u18 (ref), u17 (ref), u19 (ref), v13 (copy), v14 (copy), TTSHandlerState (copy), n1 (ref), TextUtility (copy)
	return function(p3, _: boolean) -- line: 64
		-- upvalues: t2 (copy), highlightCoreGui (copy), p2 (copy), u18 (ref), u17 (ref), u19 (ref), v13 (copy), v14 (copy), TTSHandlerState (copy), n1 (ref), TextUtility (copy)
		if not t2[p3.UserInputType] then
			highlightCoreGui.highlight(p2, u18)

			return
		end

		if u18 and u17 then
			if u19 == u18 then
				if v13 then
					v14:debug("Clicked previously read object------------------------")
				end

				if u17.State == TTSHandlerState.Playing then
					u17:Pause()

					return
				end

				if u17.State == TTSHandlerState.Idle or u17.State == TTSHandlerState.Paused then
					u17:Play()

					return
				end

				if u17.State == TTSHandlerState.Loading then
					v14:info("TTSHandler is loading, blocked input")

					return
				end
			else
				if v13 then
					v14:debug("Clicked new text------------------------")
				end

				n1 = os.clock()
				u19 = u18

				local v32 = TextUtility.retrieveDescendantText(u18)

				u17:SetText(v32)
				u17:Play()
			end
		end
	end
end

local function connectMouseOver(p4) -- line: 105
	-- upvalues: RunService (copy), n1 (ref), Properties (copy), UserInputService (copy), getCoreGuiAtPosition (copy), GuiService (copy), u18 (ref), highlightCoreGui (copy)
	RunService:BindToRenderStep("ReadAloudHighlight", Enum.RenderPriority.Input.Value + 1, function() -- line: 109
		-- upvalues: n1 (ref), Properties (copy), UserInputService (copy), getCoreGuiAtPosition (copy), GuiService (copy), u18 (ref), highlightCoreGui (copy), p4 (copy)
		if os.clock() - n1 > Properties.ReadAloudLoadCooldown and (UserInputService:GetLastInputType() == Enum.UserInputType.MouseMovement or UserInputService:GetLastInputType() == Enum.UserInputType.MouseWheel) then
			local v33 = getCoreGuiAtPosition(UserInputService:GetMouseLocation() - GuiService:GetGuiInset())

			if v33 ~= u18 then
				u18 = v33
			end
		else
			u18 = nil
		end

		highlightCoreGui.highlight(p4, u18)
	end)
end
local function disconnectMouseOver() -- line: 131
	-- upvalues: RunService (copy)
	RunService:UnbindFromRenderStep("ReadAloudHighlight")
end

function t1.Enable() -- line: 136
	-- upvalues: u17 (ref), v14 (copy), highlightCoreGui (copy), connection (ref), UserInputService (copy), TTSHandler (copy), SoundService (copy), RunService (copy), n1 (ref), Properties (copy), getCoreGuiAtPosition (copy), GuiService (copy), u18 (ref)
	if u17 then
		v14:warning("Attempted to enable Read Aloud, but it's already enabled!")

		return
	end

	local v28 = highlightCoreGui.setUpHighlight()

	connection = UserInputService.InputBegan:Connect(TriggerTTS(v28))
	u17 = TTSHandler.new()
	SoundService:SetSoundEnabled(true)
	RunService:BindToRenderStep("ReadAloudHighlight", Enum.RenderPriority.Input.Value + 1, function() -- line: 109
		-- upvalues: n1 (ref), Properties (copy), UserInputService (copy), getCoreGuiAtPosition (copy), GuiService (copy), u18 (ref), highlightCoreGui (copy), v28 (copy)
		if os.clock() - n1 > Properties.ReadAloudLoadCooldown and (UserInputService:GetLastInputType() == Enum.UserInputType.MouseMovement or UserInputService:GetLastInputType() == Enum.UserInputType.MouseWheel) then
			local v34 = getCoreGuiAtPosition(UserInputService:GetMouseLocation() - GuiService:GetGuiInset())

			if v34 ~= u18 then
				u18 = v34
			end
		else
			u18 = nil
		end

		highlightCoreGui.highlight(v28, u18)
	end)
end
function t1.Disable() -- line: 151
	-- upvalues: u17 (ref), v14 (copy), connection (ref), RunService (copy), highlightCoreGui (copy)
	if not u17 then
		v14:warning("Attempted to disable Read Aloud, but it's already disabled!")

		return
	end

	if connection then
		connection:Disconnect()
	end

	connection = nil
	u17:CleanUp()
	u17 = nil
	RunService:UnbindFromRenderStep("ReadAloudHighlight")
	highlightCoreGui.cleanUpHighlight()
end
function t1.ReadSystemTextFromKey(s1: string) -- line: 167
	-- upvalues: u17 (ref), v14 (copy), v13 (copy)
	if not u17 then
		v14:warning("Tried to read text, but Read Aloud is not enabled!")

		return
	end

	if v13 then
		v14:debug(`Requesting system TTS for key "{ s1 }"`)
	end

	u17:ReadSystemTextFromKey(s1)
end

return t1
