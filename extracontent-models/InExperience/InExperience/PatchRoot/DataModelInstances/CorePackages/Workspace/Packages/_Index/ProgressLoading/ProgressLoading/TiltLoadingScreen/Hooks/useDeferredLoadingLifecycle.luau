local ProgressLoading = script:FindFirstAncestor("ProgressLoading")
local parent = ProgressLoading.Parent

local React = require(parent.React)
local RunService = game:GetService("RunService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local LoadingScreenMilestones = require(ProgressLoading.LoadingScreenMilestones.LoadingScreenMilestones)
local Constants = require(ProgressLoading.LoadingScreenMilestones.Constants)
local SharedFlags = require(parent.SharedFlags)
local FFlagLoadingScreenMilestones = SharedFlags.FFlagLoadingScreenMilestones

local function useDeferredLoadingLifecycle(flag: boolean, instance, current)
	local state, setState = React.useState(nil)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(current)
	ref2.current = current
	local ref3 = React.useRef(false)
	local v = React.useCallback(function(flag2: boolean?, flag3: boolean?)
		if ref3.current then
			return
		end

		ref3.current = true

		if ref.current then
			ref.current.abort(Constants.AbortReason.Cancelled)
		end

		if ref2.current then
			ref2.current(flag2, flag3)
		end
	end, {})

	React.useEffect(function()
		if not flag then
			return
		end

		RunService:SetRobloxGuiFocused(true)

		local connections = {}
		local onLoadingStateChanged
		local current2

		if FFlagLoadingScreenMilestones then
			current2 = LoadingScreenMilestones.start({
				page = Constants.Page.TiltLoadingScreen,
				host = Constants.Host.DeferredJoin,
				holdEnabled = false,
				reducedMotion = UserGameSettings.ReducedMotion
			})

			ref.current = current2
			setState(current2)

			if current2 then
				current2.record(Constants.Milestone.ScreenVisible)
			end

			if current2 and instance then
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
						current2.abort(Constants.AbortReason.Unmounted)

						return
					end

					current2.dismissRequested(Constants.DismissSource.NormalReady)
					current2.record(Constants.Milestone.DismissStarted)
					current2.record(Constants.Milestone.ScreenHidden)
					current2.complete()
				end

				table.insert(connections, instance.PrefetchDownloadStatusChanged:Connect(onLoadingStateChanged))
				table.insert(
					connections,
					instance:GetPropertyChangedSignal("PregameLoadingScreenOnly"):Connect(onLoadingStateChanged)
				)

				onLoadingStateChanged()
			end
		else
			current2 = nil
		end

		return function()
			for _, connection in connections do
				connection:Disconnect()
			end

			if current2 then
				if onLoadingStateChanged then
					onLoadingStateChanged()
				end

				current2.abort(Constants.AbortReason.Unmounted)
			end

			RunService:SetRobloxGuiFocused(false)
		end
	end, { flag, instance })

	return state, v
end

return useDeferredLoadingLifecycle
