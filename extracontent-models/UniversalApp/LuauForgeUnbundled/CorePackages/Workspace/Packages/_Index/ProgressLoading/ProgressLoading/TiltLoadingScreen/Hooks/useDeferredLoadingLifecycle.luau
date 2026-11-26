local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/React")
local RunService = game:GetService("RunService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local LoadingScreenMilestones = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/LoadingScreenMilestones/LoadingScreenMilestones")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/LoadingScreenMilestones/Constants")
local fFlagLoadingScreenMilestones = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/SharedFlags").FFlagLoadingScreenMilestones

local function useDeferredLoadingLifecycle(p2, instance, current)
	local state, setState = React.useState(nil)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(current)
	ref2.current = current
	local ref3 = React.useRef(false)
	local v5 = React.useCallback(function(p3, p4)
		if ref3.current then
			return
		end

		ref3.current = true

		if ref.current then
			ref.current.abort(Constants.AbortReason.Cancelled)
		end

		if ref2.current then
			ref2.current(p3, p4)
		end
	end, {})

	React.useEffect(function()
		if not p2 then
			return
		end

		RunService:SetRobloxGuiFocused(true)

		local connections = {}
		local onLoadingStateChanged
		local v6

		if fFlagLoadingScreenMilestones then
			v6 = LoadingScreenMilestones.start({
				page = Constants.Page.TiltLoadingScreen,
				host = Constants.Host.DeferredJoin,
				holdEnabled = false,
				reducedMotion = UserGameSettings.ReducedMotion
			})

			ref.current = v6
			setState(v6)

			if v6 then
				v6.record(Constants.Milestone.ScreenVisible)
			end

			if v6 and instance then
				onLoadingStateChanged = function()
					if ref3.current then
						return
					end

					local prefetchDownloadStatus = instance:GetPrefetchDownloadStatus()

					if
						prefetchDownloadStatus == Enum.PrefetchDownloadStatus.InProgress
						or instance.PregameLoadingScreenOnly
					then
						return
					end

					if prefetchDownloadStatus ~= Enum.PrefetchDownloadStatus.Completed then
						v6.abort(Constants.AbortReason.Unmounted)

						return
					end

					v6.dismissRequested(Constants.DismissSource.NormalReady)
					v6.record(Constants.Milestone.DismissStarted)
					v6.record(Constants.Milestone.ScreenHidden)
					v6.complete()
				end

				table.insert(
					connections,
					instance.PrefetchDownloadStatusChanged:Connect(onLoadingStateChanged)
				)
				table.insert(
					connections,
					instance:GetPropertyChangedSignal("PregameLoadingScreenOnly"):Connect(onLoadingStateChanged)
				)

				onLoadingStateChanged()
			end
		else
			v6 = nil
		end

		return function()
			for k, connection in connections do
				connection:Disconnect()
			end

			if v6 then
				if onLoadingStateChanged then
					onLoadingStateChanged()
				end

				v6.abort(Constants.AbortReason.Unmounted)
			end

			RunService:SetRobloxGuiFocused(false)
		end
	end, { p2, instance })

	return state, v5
end

return useDeferredLoadingLifecycle
