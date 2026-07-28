local ShareSheet = script:FindFirstAncestor("ShareSheet")
local ShareSheetParent = ShareSheet.Parent
local Foundation = require(ShareSheetParent.Foundation)
local React = require(ShareSheetParent.React)
local useLocalization = require(ShareSheetParent.Localization).Hooks.useLocalization
local ShareSheetItemContainer = require(script.Parent.ShareSheetItemContainer)
local ShareSheetRow = require(script.Parent.ShareSheetRow)
local ShareSheetTelemetry = require(ShareSheet.telemetry.ShareSheetTelemetry)
local copyLink = require(ShareSheet.copyLink)
local shareLink = require(ShareSheet.shareLink)
local IconName = Foundation.Enums.IconName

local function ShareSheetActionRow(t1: {[any]: any}) -- line: 27
	-- upvalues: React (copy), useLocalization (copy), copyLink (copy), ShareSheetTelemetry (copy), shareLink (copy), ShareSheetRow (copy), ShareSheetItemContainer (copy), IconName (copy)
	local v14, v15 = React.useState(false)
	local v16 = React.useRef(nil)
	local v17 = useLocalization({
		copyLink = "Feature.SocialShare.Action.CopyLink",
		share = "Feature.SocialShare.Action.Share"
	})
	local v18 = React.useCallback(function() -- line: 34
		-- upvalues: copyLink (copy), t1 (copy), v15 (copy), v16 (copy), ShareSheetTelemetry (copy)
		copyLink({
			context = t1.context,
			url = t1.url
		})
		v15(true)

		if v16.current then
			task.cancel(v16.current)
		end

		v16.current = task.delay(2, function() -- line: 43
			-- upvalues: v16 (copy), v15 (copy)
			v16.current = nil
			v15(false)
		end)
		ShareSheetTelemetry.logShareSheetLinkCopied({
			context = t1.context,
			url = t1.url,
			telemetryId = t1.telemetryId or ""
		})
	end, {
		t1.context,
		t1.url,
		t1.telemetryId
	})
	local v19 = React.useCallback(function() -- line: 54
		-- upvalues: shareLink (copy), t1 (copy)
		shareLink({
			context = t1.context,
			url = t1.url
		})
	end, {
		t1.context,
		t1.url
	})

	React.useEffect(function() -- line: 60
		-- upvalues: v16 (copy)
		return function() -- line: 61
			-- upvalues: v16 (copy)
			if v16.current then
				task.cancel(v16.current)
			end
		end
	end, {})

	return React.createElement(ShareSheetRow, {
		LayoutOrder = t1.LayoutOrder
	}, {
		CopyLink = React.createElement(ShareSheetItemContainer, {
			LayoutOrder = 1,
			icon = if not v14 then IconName.ChainLink else IconName.Check,
			label = if not v14 then v17.copyLink else "Copied",
			onActivated = v18,
			shouldAnimate = v14
		}),
		Share = if not t1.canShare then nil else React.createElement(ShareSheetItemContainer, {
			LayoutOrder = 2,
			icon = IconName.ArrowUpFromLandscapeRectangle,
			label = v17.share,
			onActivated = v19
		})
	})
end

return ShareSheetActionRow
