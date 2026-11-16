local parent = script:FindFirstAncestor("Moments").Parent

local Signals = require(parent.Signals)
local SharedFlags = require(parent.SharedFlags)
local FFlagMomentsComments = SharedFlags.FFlagMomentsComments
require(script.Parent.Parent.createCommentsRecommendationSession)
local CommentsSheetSnapPoints = require(script.Parent.CommentsSheetSnapPoints)
require(script.Parent.getCommentsVideoLift)

require(script.Parent.Parent.createCommentsAnalyticsSession)

local function createCommentsSheetStore()
	local signal, v = Signals.createSignal(false)

	local signal2, v2 = Signals.createSignal(nil)
	local signal3, v3 = Signals.createSignal(0)

	local signal4, v4 = Signals.createSignal(true)

	local signal5, setVideoLift = Signals.createSignal(nil)
	local signal6, v5 = Signals.createSignal(false)
	local v6 = nil
	local v7 = nil
	local v8 = nil

	return {
		getIsOpen = signal,
		getFeedItemId = signal2,
		getOpenSessionId = signal3,
		getIsListScrollingEnabled = signal4,
		getVideoLift = signal5,
		getIsExpanded = signal6,
		getRecommendationSession = function(p: string, p2: number)
			if signal2(false) == p and signal3(false) == p2 then
				return v6
			end

			return nil
		end,
		getAnalyticsSession = function(p: string, p2: number)
			if signal2(false) == p and signal3(false) == p2 then
				return v7
			end

			return nil
		end,
		getTarget = function(p: string, p2: number)
			if signal2(false) == p and signal3(false) == p2 then
				return v8
			end

			return nil
		end,
		open = function(p: string, p2, p3, p4)
			if FFlagMomentsComments then
				if v7 ~= nil then
					v7.finishView("replaced")
				end

				v7 = p3

				if v7 ~= nil then
					v7.open()
				end
			end

			if FFlagMomentsComments then
				if v6 ~= nil then
					v6.finishView()
				end

				v6 = p2
			end

			v8 = p4
			v2(p)
			v3(signal3(false) + 1)
			v4(true)
			setVideoLift(nil)
			v5(false)
			v(true)
		end,
		close = function(value)
			if FFlagMomentsComments and v7 ~= nil then
				v7.finishView(value or "closed")
			end

			if FFlagMomentsComments and v6 ~= nil then
				v6.finishView()
			end

			v8 = nil

			v5(false)
			v(false)
		end,
		reset = function()
			if FFlagMomentsComments and v7 ~= nil then
				v7.cancel()
				v7 = nil
			end

			if FFlagMomentsComments and v6 ~= nil then
				v6.cancel()
				v6 = nil
			end

			v8 = nil
			v(false)
			v2(nil)
			v3(signal3(false) + 1)
			v4(true)
			setVideoLift(nil)
			v5(false)
		end,
		setSnapPointIndex = function(p: number)
			v4(p == #CommentsSheetSnapPoints)
			v5(p == #CommentsSheetSnapPoints)
		end,
		setVideoLift = setVideoLift
	}
end

return createCommentsSheetStore
