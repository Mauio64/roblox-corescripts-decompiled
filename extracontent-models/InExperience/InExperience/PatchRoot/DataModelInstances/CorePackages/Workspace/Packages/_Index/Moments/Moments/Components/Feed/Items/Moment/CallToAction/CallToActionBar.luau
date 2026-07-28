local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local Foundation = require(MomentsParent.Foundation)
local Localization = require(MomentsParent.Localization)
local React = require(MomentsParent.React)
local SignalsReact = require(MomentsParent.SignalsReact)
local Button = Foundation.Button
local Skeleton = Foundation.Skeleton
local FoundationText = Foundation.Text
local View = Foundation.View
local EnumsRadius = Foundation.Enums.Radius
local getRbxThumb = Foundation.Utility.getRbxThumb
local useTokens = Foundation.Hooks.useTokens
local useScaledValue = Foundation.Hooks.useScaledValue
local useLocalization = Localization.Hooks.useLocalization
local useSignalState = SignalsReact.useSignalState
local useExperienceDetails = require(Moments.Hooks.useExperienceDetails)
local useIsTvRemoteDevice = require(MomentsParent.RoactUtils).Hooks.useIsTvRemoteDevice
local GetMomentsPreferencesStore = require(Moments.Stores.GetMomentsPreferencesStore)
local GetFFlagMomentsAndroidTvEnabled = require(Moments.Flags.GetFFlagMomentsAndroidTvEnabled)
local ImageWithSkeleton = require(Moments.Components.ImageWithSkeleton)
local MomentContext = require(script.Parent.Parent.MomentContext)
local getExperienceDetailsSheetStore = require(Moments.ExperienceDetailsSheet.Sheet.getExperienceDetailsSheetStore)
local JoinButton = require(Moments.ExperienceDetailsSheet.Join.JoinButton)
local t1 = {
	join = "Feature.Moments.Action.Join"
}
local v26 = utf8.char(57344)

local function CallToActionBar(t2: {[any]: any}) -- line: 57
	-- upvalues: useLocalization (copy), t1 (copy), useTokens (copy), MomentContext (copy), useSignalState (copy), GetMomentsPreferencesStore (copy), GetFFlagMomentsAndroidTvEnabled (copy), useIsTvRemoteDevice (copy), useExperienceDetails (copy), useScaledValue (copy), getRbxThumb (copy), Foundation (copy), v26 (copy), React (copy), ImageWithSkeleton (copy), EnumsRadius (copy), View (copy), FoundationText (copy), Skeleton (copy), getExperienceDetailsSheetStore (copy), Button (copy), JoinButton (copy)
	local v29 = useLocalization(t1)
	local v30 = useTokens()
	local store = MomentContext.useMoment().store
	local v32 = store.getData(false)
	local v33 = v32.kind == "ad"
	local v34 = if v32.kind ~= "ad" then nil else v32.advertiser
	local v35 = v32.kind ~= "experience" and 0 or v32.placeId
	local v36 = v32.kind ~= "experience" and 0 or v32.universeId
	local v37 = useSignalState(GetMomentsPreferencesStore(false).getIsTeleporting)
	local v38 = useSignalState(store.getIsModerated)
	local v39 = GetFFlagMomentsAndroidTvEnabled()
	local v40 = useIsTvRemoteDevice()
	local v41 = useExperienceDetails(if not v33 then v36 else nil)
	local v42 = useScaledValue(160)
	local v43 = if not v33 then if v36 == 0 then getRbxThumb(Foundation.Enums.ThumbnailType.Asset, v35) else getRbxThumb(Foundation.Enums.ThumbnailType.GameIcon, v36) else if not v34 then nil else v34.iconImage

	if not v33 and v35 == 0 then
		return nil
	end

	local v44 = if not v33 then v41.name else if not v34 then nil else v34.title
	local v45 = if not v33 then v41.creatorName else if not v34 then nil else v34.subtitle
	local v46 = if not v33 then v41.isCreatorVerified == true else v34 ~= nil and v34.isVerified
	local v47 = if not v33 or not v34 then v29.join else v34.ctaText
	local v48 = if not v45 or not v46 then v45 else `{ v45 } { v26 }`
	local Size_1000 = v30.Size.Size_1000
	local v50 = React.createElement(ImageWithSkeleton, {
		LayoutOrder = 1,
		Image = v43,
		Size = UDim2.fromOffset(Size_1000, Size_1000),
		radius = EnumsRadius.Medium,
		backgroundStyle = v30.Color.Shift.Shift_300
	})
	local v51 = React.createElement(View, {
		LayoutOrder = 2,
		tag = "col align-x-left align-y-center grow gap-xsmall auto-y"
	}, {
		Title = if not v44 then React.createElement(Skeleton, {
			LayoutOrder = 1,
			Size = UDim2.fromOffset(v42, v30.Size.Size_400)
		}) else React.createElement(FoundationText, {
			LayoutOrder = 1,
			tag = "size-full-0 auto-y text-title-medium text-align-x-left text-align-y-top text-truncate-end content-emphasis",
			Text = v44
		}),
		Subtitle = if not v48 then nil else React.createElement(FoundationText, {
			LayoutOrder = 2,
			tag = "auto-xy text-body-medium text-align-x-left text-align-y-center text-truncate-end content-default",
			Text = v48
		})
	})
	local v52 = React.createElement(View, {
		LayoutOrder = 1,
		tag = "row align-x-left align-y-center grow gap-medium auto-y",
		testId = "moments-experience-row",
		onActivated = if v33 or v38 then nil else function() -- line: 145
			-- upvalues: getExperienceDetailsSheetStore (copy), v35 (copy), v36 (copy), v32 (copy)
			getExperienceDetailsSheetStore(false).open({
				placeId = v35,
				universeId = v36,
				itemId = v32.feedItemId,
				feedItemId = v32.feedItemId,
				tracingId = v32.feedSessionId
			})
		end,
		stateLayer = if v33 or v38 then nil else {
			affordance = Foundation.Enums.StateLayerAffordance.None
		},
		selection = if not v39 or not v40 then nil else {
			Selectable = false
		}
	}, {
		Thumbnail = v50,
		Metadata = v51
	})

	return React.createElement(View, {
		tag = "row align-x-left align-y-center gap-medium size-full-0 auto-y",
		LayoutOrder = t2.LayoutOrder
	}, {
		MediaAndMetadata = v52,
		CtaButton = if not v39 or not v40 then if not v33 then React.createElement(JoinButton, {
			LayoutOrder = 2,
			context = {
				placeId = v35,
				universeId = v36,
				itemId = v32.feedItemId,
				feedItemId = v32.feedItemId,
				tracingId = v32.feedSessionId
			},
			text = v47,
			isDisabled = v38
		}) else React.createElement(Button, {
			LayoutOrder = 2,
			isDisabled = v37 or v38,
			onActivated = function() -- line: 176
			end,
			size = Foundation.Enums.InputSize.Medium,
			text = v47,
			variant = Foundation.Enums.ButtonVariant.Emphasis
		}) else nil
	})
end

return React.memo(CallToActionBar)
