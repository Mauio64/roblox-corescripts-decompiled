local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Signals")

local CreationFlowState = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Enums/CreationFlowState")

local createSignal = Signals.createSignal

local gallery = CreationFlowState.Gallery
local preview = CreationFlowState.Preview
local music = CreationFlowState.Music
local textOverlay = CreationFlowState.TextOverlay
local trimming = CreationFlowState.Trimming
local description = CreationFlowState.Description
local stickerOverlay = CreationFlowState.StickerOverlay
local voice = CreationFlowState.Voice

local v5 = {
	[gallery] = { [preview] = true },
	[preview] = {
		[gallery] = true,
		[trimming] = true,
		[music] = true,
		[textOverlay] = true,
		[voice] = true,
		[description] = true,
		[stickerOverlay] = true
	},
	[trimming] = { [preview] = true },
	[music] = { [preview] = true },
	[textOverlay] = { [preview] = true },
	[voice] = { [preview] = true },
	[description] = { [preview] = true },
	[stickerOverlay] = { [preview] = true }
}

local function createNavigationMachine(p2)
	local signal, v6 = createSignal(p2 or gallery)

	return {
		getStep = signal,
		canNavigate = function(p3): boolean
			local v7 = signal(false)

			if v7 == p3 then
				return true
			end

			local v8 = v5[v7]
			return v8 ~= nil and v8[p3] == true
		end,
		navigate = function(p3): boolean
			local v7 = signal(false)
			local v8

			if v7 == p3 then
				v8 = true
			else
				local v9 = v5[v7]
				v8 = not (v9 == nil) and v9[p3] == true
			end

			if not v8 then
				return false
			end

			v6(p3)
			return true
		end,
		reset = function(p3)
			v6(p3)
		end
	}
end

return createNavigationMachine
