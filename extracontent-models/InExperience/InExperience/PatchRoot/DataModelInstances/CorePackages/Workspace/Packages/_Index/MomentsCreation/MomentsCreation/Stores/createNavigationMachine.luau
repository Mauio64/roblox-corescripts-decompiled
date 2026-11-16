local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local Signals = require(parent.Signals)

local CreationFlowState = require(MomentsCreation.Enums.CreationFlowState)

local createSignal = Signals.createSignal

local Gallery = CreationFlowState.Gallery
local Preview = CreationFlowState.Preview
local Music = CreationFlowState.Music
local TextOverlay = CreationFlowState.TextOverlay
local Trimming = CreationFlowState.Trimming
local Description = CreationFlowState.Description
local StickerOverlay = CreationFlowState.StickerOverlay
local Voice = CreationFlowState.Voice

local v = {
	[Gallery] = { [Preview] = true },
	[Preview] = {
		[Gallery] = true,
		[Trimming] = true,
		[Music] = true,
		[TextOverlay] = true,
		[Voice] = true,
		[Description] = true,
		[StickerOverlay] = true
	},
	[Trimming] = { [Preview] = true },
	[Music] = { [Preview] = true },
	[TextOverlay] = { [Preview] = true },
	[Voice] = { [Preview] = true },
	[Description] = { [Preview] = true },
	[StickerOverlay] = { [Preview] = true }
}

local function createNavigationMachine(p)
	local signal, v2 = createSignal(p or Gallery)

	local function canNavigate(p2): boolean -- 1 equivalent call inferred from this helper
		local v3 = signal(false)

		if v3 == p2 then
			return true
		end

		local v4 = v[v3]
		return v4 ~= nil and v4[p2] == true
	end

	return {
		getStep = signal,
		canNavigate = canNavigate,
		navigate = function(p2): boolean
			if not canNavigate(p2) then -- inferred equivalent call
				return false
			end

			v2(p2)
			return true
		end,
		reset = function(p2)
			v2(p2)
		end
	}
end

return createNavigationMachine
