local SduiSharedContent = script:FindFirstAncestor("SduiSharedContent")
local SduiSharedContentParent = SduiSharedContent.Parent
local React = require(SduiSharedContentParent.React)
local Foundation = require(SduiSharedContentParent.Foundation)
local Navigation = require(SduiSharedContentParent.Navigation)
local Drawer = require(SduiSharedContentParent.Drawer)
local RoactUtils = require(SduiSharedContentParent.RoactUtils)
local SignalsReact = require(SduiSharedContentParent.SignalsReact)
local StreamNotifications = require(SduiSharedContentParent.StreamNotifications)
local sendCoachmarkImpression = require(SduiSharedContent.Analytics.sendCoachmarkImpression)
local v11 = game:DefineFastFlag("LuaAppUseNavFocusInSduiCoachmark", false)
local v12 = game:DefineFastFlag("LuaAppCoachmarkImpression", false)
local v13 = game:DefineFastFlag("LuaAppHideSduiCoachmarkWhenFlyoutOpen", false)
local v14 = game:DefineFastFlag("LuaAppHideSduiCoachmarkWhenCentralOverlayOpen", false)
local v15 = game:DefineFastFlag("LuaAppHideSduiCoachmarkWhenNotificationStreamOpen", false)
local Coachmark = Foundation.Coachmark
local useNavigationFocus = Navigation.useNavigationFocus
local useDrawerVisible = Drawer.Hooks.useDrawerVisible
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useSignalState = SignalsReact.useSignalState
local StreamNotificationStore = StreamNotifications.StreamNotificationStore
local CollectionService = game:GetService("CollectionService")

local function SduiCoachmark(t1: {[any]: any}) -- line: 46
	-- upvalues: React (copy), v11 (copy), useNavigationFocus (copy), v13 (copy), useDrawerVisible (copy), v14 (copy), useSelector (copy), v15 (copy), useSignalState (copy), StreamNotificationStore (copy), CollectionService (copy), v12 (copy), sendCoachmarkImpression (copy), Coachmark (copy)
	local v25 = React.useRef(nil)
	local v26, v27 = React.useState(false)
	local v28, v29 = React.useState(false)
	local v30 = if not v11 then nil else useNavigationFocus()
	local v31 = not not v13 and useDrawerVisible()
	local v32 = if not v14 then nil else useSelector(function(p1) -- line: 53
		return p1.CentralOverlay.OverlayType ~= nil
	end)
	local v33 = if not v15 then nil else useSignalState(StreamNotificationStore.getStreamPresented)

	React.useEffect(function() -- line: 61
		-- upvalues: v25 (copy), v29 (copy), CollectionService (copy), t1 (copy)
		local function onTagAdded(p2) -- line: 62
			-- upvalues: v25 (copy), v29 (copy)
			if not p2:IsA("GuiObject") then
				return
			end

			v25.current = p2
			v29(true)
		end
		local function onTagRemoved(_) -- line: 70
			-- upvalues: v25 (copy), v29 (copy)
			v25.current = nil
			v29(false)
		end

		for _, v41 in (CollectionService:GetTagged(t1.collectionServiceAnchorTag)) do
			if v41:IsA("GuiObject") then
				if not v41:IsA("GuiObject") then
					break
				end

				v25.current = v41
				v29(true)

				break
			end
		end

		local connection = CollectionService:GetInstanceAddedSignal(t1.collectionServiceAnchorTag):Connect(onTagAdded)
		local connection2 = CollectionService:GetInstanceRemovedSignal(t1.collectionServiceAnchorTag):Connect(onTagRemoved)

		return function() -- line: 87
			-- upvalues: connection (copy), connection2 (copy)
			connection:Disconnect()
			connection2:Disconnect()
		end
	end, { t1.collectionServiceAnchorTag })

	local v34 = React.useCallback(function() -- line: 93
		-- upvalues: v27 (copy), t1 (copy)
		v27(true)

		if t1.onClose then
			t1.onClose()
		end
	end, { t1.onClose })

	if v12 then
		local v35 = React.useRef(false)
		local v36 = v28 and (not v26 and (not (v11 and not v30) and (not (v13 and v31) and (not (v14 and v32) and not (v15 and v33)))))

		React.useEffect(function() -- line: 110
			-- upvalues: v36 (copy), v35 (copy), t1 (copy), sendCoachmarkImpression (copy)
			if not v36 or v35.current then
				return
			end

			local media = t1.media
			local v45 = media ~= nil

			if typeof(media) == "table" and next(media) == nil then
				v45 = false
			end

			sendCoachmarkImpression(t1.collectionServiceAnchorTag, v45)
			v35.current = true
		end, {
			v36,
			t1.collectionServiceAnchorTag,
			t1.media
		})

		if not v36 then
			return nil
		end
	elseif not v28 or v26 or v11 and not v30 or v13 and v31 or v14 and v32 or v15 and v33 then
		return nil
	end

	return React.createElement(Coachmark, {
		title = t1.title,
		text = t1.body,
		isOpen = not not v11 or v28 and not v26,
		side = t1.side,
		align = t1.align,
		anchorRef = v25,
		onClose = v34,
		actions = t1.actions,
		media = t1.media,
		testId = t1.testId
	})
end

return React.memo(SduiCoachmark)
