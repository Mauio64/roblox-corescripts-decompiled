local LocalizationService = game:GetService("LocalizationService")
local UserInputService = game:GetService("UserInputService")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")
local MomentsGetMomentsCommentsStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsGetMomentsCommentsStore")

require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/Composer/CommentsComposerContainer")

require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/Panel/CommentsPanelBody/CommentsPanelBodyContainer")
local GetCommentCollectionStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/GetCommentCollectionStore")
local getCommentsPanelState = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/Panel/getCommentsPanelState")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/SheetShim")
local useCommentCapabilities = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/useCommentCapabilities")
local FFlagMomentsCommentsAttachSheetScroller = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsCommentsAttachSheetScroller")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/Sheet/CommentsSheetView")
local getCommentsSheetStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/Sheet/getCommentsSheetStore")
local getCommentsVideoLift = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/Sheet/getCommentsVideoLift")
local useSheetContentScrollingFrame = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/Sheet/useSheetContentScrollingFrame")

local useLocalization = Localization.Hooks.useLocalization

local function useCommentsSheetViewModel()
	local v5 = getCommentsSheetStore(false)
	local v6 = SignalsReact.useSignalState(v5.getIsOpen)
	local v7 = SignalsReact.useSignalState(v5.getFeedItemId)
	local v8 = SignalsReact.useSignalState(v5.getOpenSessionId)
	local v9 = MomentsGetMomentsCommentsStore(false)
	local v10 = React.useMemo(function()
		return v9.getCachedMomentComments(v7 or "")
	end, { v9, v7 })
	local v11 = SignalsReact.useSignalState(v10.data)
	local v12 = useCommentCapabilities()

	local close = v5.close
	React.useEffect(function()
		if v6 and not v12.canRead then
			close()
		end
	end, { v6, v12.canRead, close })
	local ref = React.useRef(nil)
	local state, setState = React.useState(nil)
	local v13 = GetCommentCollectionStore(false)
	local v14 = v7 or ""
	local v15 = React.useMemo(function()
		return v13.getState(v14)
	end, { v13, v14 })
	local v16 = SignalsReact.useSignalState(v15)
	local v17 = v16.pendingSubmission == nil and 0 or 1
	local v18

	if v16.initialLoadStatus == "Success" and not v16.hasMore then
		v18 = math.max(0, #v16.orderedCommentIds - v17)
	end

	if v11 ~= nil and v11.count ~= nil then
		v18 = v11.count
	end

	local v19

	if v18 ~= nil then
		v19 = Localization.abbreviateCount(v18, LocalizationService.RobloxLocaleId)
	end

	local v20 = getCommentsPanelState(v11, v16)
	local v21 = v20.contentState == "list" and v7 ~= nil
	local v22, v23

	if FFlagMomentsCommentsAttachSheetScroller then
		v22, v23 = useSheetContentScrollingFrame(v21)
	end

	local title = useLocalization({
		title = (v18 == nil or not (v18 > 0) or v19 == nil) and "Feature.Moments.Title.Comments" or {
			(v11 == nil or not v11.countIsCapped) and "Feature.Moments.Title.CommentsWithCount" or "Feature.Moments.Title.CommentsWithCappedCount",
			count = v19
		}
	}).title
	local v25

	if v6 then
		v25 = not (v7 == nil or v7 == "") and (v12.canRead and v12.canWrite and v20.canCompose)
	else
		v25 = v6
	end

	local setSnapPointIndex = v5.setSnapPointIndex
	local v26 = React.useCallback(function(p2, p3)
		setSnapPointIndex(p3)
	end, { setSnapPointIndex })

	local v27 = Foundation.Hooks.useOverlay()
	local getVideoLift = v5.getVideoLift
	local setVideoLift = v5.setVideoLift
	local v28 = React.useCallback(function(p2)
		if v27 == nil then
			setVideoLift(nil)
		else
			setVideoLift(getCommentsVideoLift(
				{
					sheetInset = p2.bottom,
					overlayTop = v27.AbsolutePosition.Y,
					overlayHeight = v27.AbsoluteSize.Y,
					isKeyboardVisible = UserInputService.OnScreenKeyboardVisible
				},
				getVideoLift(false)
			))
		end
	end, { v27, getVideoLift, setVideoLift })

	React.useEffect(function()
		return function()
			setVideoLift(nil)
		end
	end, { setVideoLift })

	return {
		isOpen = v6,
		title = title,
		onClose = v5.close,
		onSnapPointChanged = v26,
		onContentInsetChanged = v28,
		isListDisplayed = v21,
		scrollingFrameRef = ref,
		onScrollingFrameChanged = v23,
		actionsRef = setState,
		panelBodyProps = {
			isOpen = v6,
			feedItemId = v7,
			comments = v11,
			panelState = v20,
			sessionId = v8,
			scrollingFrameRef = ref,
			scrollingFrame = v22,
			actionsFrame = state,
			onClose = v5.close
		},
		composerProps = v25 and { feedItemId = v7, sessionId = v8 } or nil
	}
end

return useCommentsSheetViewModel
