local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local fFlagMomentsComments = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags").FFlagMomentsComments
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/createCommentsRecommendationSession")
local CommentsSheetSnapPoints = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/Sheet/CommentsSheetSnapPoints")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/Sheet/getCommentsVideoLift")

require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/createCommentsAnalyticsSession")

local function createCommentsSheetStore()
	local signal, v5 = Signals.createSignal(false)

	local signal2, v6 = Signals.createSignal(nil)
	local signal3, v7 = Signals.createSignal(0)

	local signal4, v8 = Signals.createSignal(true)

	local signal5, v9 = Signals.createSignal(nil)
	local signal6, v10 = Signals.createSignal(false)
	local v11 = nil
	local v12 = nil
	local v13 = nil

	return {
		getIsOpen = signal,
		getFeedItemId = signal2,
		getOpenSessionId = signal3,
		getIsListScrollingEnabled = signal4,
		getVideoLift = signal5,
		getIsExpanded = signal6,
		getRecommendationSession = function(p2, p3)
			if signal2(false) == p2 and signal3(false) == p3 then
				return v11
			end

			return nil
		end,
		getAnalyticsSession = function(p2, p3)
			if signal2(false) == p2 and signal3(false) == p3 then
				return v12
			end

			return nil
		end,
		getTarget = function(p2, p3)
			if signal2(false) == p2 and signal3(false) == p3 then
				return v13
			end

			return nil
		end,
		open = function(p2, p3, p4, p5)
			if fFlagMomentsComments then
				if v12 ~= nil then
					v12.finishView("replaced")
				end

				v12 = p4

				if v12 ~= nil then
					v12.open()
				end
			end

			if fFlagMomentsComments then
				if v11 ~= nil then
					v11.finishView()
				end

				v11 = p3
			end

			v13 = p5
			v6(p2)
			v7(signal3(false) + 1)
			v8(true)
			v9(nil)
			v10(false)
			v5(true)
		end,
		close = function(value)
			if fFlagMomentsComments and v12 ~= nil then
				v12.finishView(value or "closed")
			end

			if fFlagMomentsComments and v11 ~= nil then
				v11.finishView()
			end

			v13 = nil

			v10(false)
			v5(false)
		end,
		reset = function()
			if fFlagMomentsComments and v12 ~= nil then
				v12.cancel()
				v12 = nil
			end

			if fFlagMomentsComments and v11 ~= nil then
				v11.cancel()
				v11 = nil
			end

			v13 = nil
			v5(false)
			v6(nil)
			v7(signal3(false) + 1)
			v8(true)
			v9(nil)
			v10(false)
		end,
		setSnapPointIndex = function(p2)
			v8(p2 == #CommentsSheetSnapPoints)
			v10(p2 == #CommentsSheetSnapPoints)
		end,
		setVideoLift = v9
	}
end

return createCommentsSheetStore
