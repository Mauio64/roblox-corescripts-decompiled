local createSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Signals").createSignal

local function createMarqueeSessionStore()
	local signal, v5 = createSignal({})
	local signal2, v6 = createSignal(0)
	local currentScroll = nil
	local heldScroll = nil
	local flag = false
	local count = 0

	return {
		getLoopsRemaining = signal,
		getHomeFocusVersion = signal2,
		notifyHomeFocused = function()
			v6(signal2(false) + 1)
		end,
		reset = function()
			v5({})
			currentScroll = nil
			flag = false
			heldScroll = nil
		end,
		setCurrentScroll = function(p2, p3)
			currentScroll = { tileId = p2, offset = p3 }

			if flag then
				heldScroll = currentScroll
			end
		end,
		getCurrentScroll = function()
			return currentScroll
		end,
		clearCurrentScroll = function(p2)
			if currentScroll ~= nil and currentScroll.tileId == p2 then
				currentScroll = nil
			end

			if heldScroll ~= nil and heldScroll.tileId == p2 then
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
		discardHeldScroll = function()
			flag = false
			heldScroll = nil
		end,
		isScrollHeld = function()
			return flag
		end,
		beginMount = function()
			count += 1
			return count
		end,
		isCurrentMount = function(p2): boolean
			return count == p2
		end
	}
end

return createMarqueeSessionStore
