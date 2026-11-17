local parent = script:FindFirstAncestor("SocialCarousel").Parent

local Signals = require(parent.Signals)

local createSignal = Signals.createSignal

local function createMarqueeSessionStore()
	local signal, v = createSignal({})
	local signal2, v2 = createSignal(0)
	local currentScroll = nil
	local heldScroll = nil
	local flag = false
	local count = 0

	local function discardHeldScroll() -- 1 equivalent call inferred from this helper
		flag = false
		heldScroll = nil
	end

	return {
		getLoopsRemaining = signal,
		getHomeFocusVersion = signal2,
		notifyHomeFocused = function()
			v2(signal2(false) + 1)
		end,
		reset = function()
			v({})
			currentScroll = nil
			discardHeldScroll() -- inferred equivalent call
		end,
		setCurrentScroll = function(tileId: string, offset: number)
			currentScroll = { tileId = tileId, offset = offset }

			if flag then
				heldScroll = currentScroll
			end
		end,
		getCurrentScroll = function()
			return currentScroll
		end,
		clearCurrentScroll = function(p: string)
			if currentScroll ~= nil and currentScroll.tileId == p then
				currentScroll = nil
			end

			if heldScroll ~= nil and heldScroll.tileId == p then
				heldScroll = nil
			end
		end,
		holdCurrentScroll = function()
			flag = true

			if currentScroll ~= nil then
				heldScroll = currentScroll
			end
		end,
		getHeldScroll = function()
			return heldScroll
		end,
		discardHeldScroll = discardHeldScroll,
		isScrollHeld = function()
			return flag
		end,
		beginMount = function()
			count += 1
			return count
		end,
		isCurrentMount = function(p: number): boolean
			return count == p
		end
	}
end

return createMarqueeSessionStore
