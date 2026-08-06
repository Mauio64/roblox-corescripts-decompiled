local InGameAssetReporting = script:FindFirstAncestor("InGameAssetReporting")
local InGameAssetReportingParent = InGameAssetReporting.Parent
local Localization = require(InGameAssetReportingParent.Localization)
local React = require(InGameAssetReportingParent.React)
local View = require(InGameAssetReportingParent.Foundation).View
local DsaIllegalContentReporting = require(InGameAssetReportingParent.DsaIllegalContentReporting)
local isShowUKOSAIllegalContentReportingLink = DsaIllegalContentReporting.isShowUKOSAIllegalContentReportingLink
local OSAReportLink = DsaIllegalContentReporting.OSAReportLink
local useLocalization = Localization.Hooks.useLocalization
local DefaultDualDropdownDialog = require(InGameAssetReportingParent.GenericAbuseReporting.DefaultDualDropdownDialog)
local DefaultDualDropdownDialogV2 = require(InGameAssetReportingParent.GenericAbuseReporting.DefaultDualDropdownDialogV2)
local Constants = require(InGameAssetReporting.InGameAssetReportUI.Resources.Constants)
local getPreselectedSurfaceValue = require(InGameAssetReporting.Utility.getPreselectedSurfaceValue)

require(InGameAssetReporting.Analysis.SceneAnalysis)

local FFlagPrefillPreciseSelectionChoices = require(InGameAssetReportingParent.SharedFlags).FFlagPrefillPreciseSelectionChoices
local FFlagGenericAbuseReportingGranularExports = require(InGameAssetReportingParent.SharedFlags).FFlagGenericAbuseReportingGranularExports

local function InGameAssetReportSubmitDialog(t1: {[any]: any}) -- line: 36
	-- upvalues: FFlagPrefillPreciseSelectionChoices (copy), useLocalization (copy), getPreselectedSurfaceValue (copy), React (copy), Constants (copy), DefaultDualDropdownDialogV2 (copy), DefaultDualDropdownDialog (copy), FFlagGenericAbuseReportingGranularExports (copy), isShowUKOSAIllegalContentReportingLink (copy), View (copy), OSAReportLink (copy)
	local u18 = nil

	if FFlagPrefillPreciseSelectionChoices then
		u18 = useLocalization({
			title = "Feature.ReportAbuse.Title.SelectInSceneFinishYourReport",
			problemBullying = "Feature.ReportAbuse.Problem.Bullying",
			problemBullyingDesc = "Feature.ReportAbuse.ProblemDescription.Bullying",
			problemCheating = "Feature.ReportAbuse.Problem.Cheating",
			problemCheatingDesc = "Feature.ReportAbuse.ProblemDescription.Cheating",
			problemDating = "Feature.ReportAbuse.Problem.Dating",
			problemDatingDesc = "Feature.ReportAbuse.ProblemDescription.Dating",
			problemHate = "Feature.ReportAbuse.Problem.Hate",
			problemHateDesc = "Feature.ReportAbuse.ProblemDescription.Hate",
			problemLinks = "Feature.ReportAbuse.Problem.Links",
			problemLinksDesc = "Feature.ReportAbuse.ProblemDescription.Links",
			problemPersonal = "Feature.ReportAbuse.Problem.Personal",
			problemPersonalDesc = "Feature.ReportAbuse.ProblemDescription.Personal",
			problemScamming = "Feature.ReportAbuse.Problem.Scamming",
			problemScammingDesc = "Feature.ReportAbuse.ProblemDescription.Scamming",
			problemSwearing = "Feature.ReportAbuse.Problem.Swearing",
			problemSwearingDesc = "Feature.ReportAbuse.ProblemDescription.Swearing",
			problemViolence = "Feature.ReportAbuse.Problem.Violence",
			problemViolenceDesc = "Feature.ReportAbuse.ProblemDescription.Violence",
			surfaceAvatar = "Feature.ReportAbuse.ProblemSurface.Avatar",
			surfaceDrawing = "Feature.ReportAbuse.ProblemSurface.DrawingOrCreation",
			surfaceExperience = "Feature.ReportAbuse.ProblemSurface.Experience",
			surfaceItem = "Feature.ReportAbuse.ProblemSurface.ItemOrAsset",
			surfaceMovement = "Feature.ReportAbuse.ProblemSurface.Movement",
			surfaceMusic = "Feature.ReportAbuse.ProblemSurface.MusicOrSoundEffect",
			surfaceTextChat = "Feature.ReportAbuse.ProblemSurface.TextChat",
			surfaceUsername = "Feature.ReportAbuse.ProblemSurface.Username",
			problemIPInfringement = "Feature.ReportAbuse.Problem.IpInfringement",
			problemIPInfringementDesc = "Feature.ReportAbuse.ProblemDescription.IpInfringement"
		})
	end

	if FFlagPrefillPreciseSelectionChoices then
		local v19 = getPreselectedSurfaceValue(t1.extractionResult)
		local v20 = if v19 ~= "avatar" then if v19 ~= "item" then if v19 ~= "text" then nil else u18.surfaceTextChat else u18.surfaceItem else u18.surfaceAvatar

		React.useEffect(function() -- line: 80
			-- upvalues: v20 (copy), t1 (copy), Constants (copy)
			if v20 then
				t1.analyticsDispatch({
					type = Constants.AnalyticsActions.SetPrefilledSurfaceSelection,
					prefilled_surface_selection = v20
				})
			end
		end, { v20 })

		local v21 = React.useMemo(function() -- line: 89
			-- upvalues: u18 (ref)
			return {
				{
					value = "bullying",
					label = u18.problemBullying,
					description = u18.problemBullyingDesc
				},
				{
					value = "exploiting",
					label = u18.problemCheating,
					description = u18.problemCheatingDesc
				},
				{
					value = "dating",
					label = u18.problemDating,
					description = u18.problemDatingDesc
				},
				{
					value = "hate",
					label = u18.problemHate,
					description = u18.problemHateDesc
				},
				{
					value = "offsite links",
					label = u18.problemLinks,
					description = u18.problemLinksDesc
				},
				{
					value = "personal question",
					label = u18.problemPersonal,
					description = u18.problemPersonalDesc
				},
				{
					value = "scamming",
					label = u18.problemScamming,
					description = u18.problemScammingDesc
				},
				{
					value = "swearing",
					label = u18.problemSwearing,
					description = u18.problemSwearingDesc
				},
				{
					value = "violence",
					label = u18.problemViolence,
					description = u18.problemViolenceDesc
				},
				{
					value = "ip infringement",
					label = u18.problemIPInfringement,
					description = u18.problemIPInfringementDesc
				}
			}
		end, {
			u18.problemBullying,
			u18.problemBullyingDesc,
			u18.problemCheating,
			u18.problemCheatingDesc,
			u18.problemDating,
			u18.problemDatingDesc,
			u18.problemHate,
			u18.problemHateDesc,
			u18.problemLinks,
			u18.problemLinksDesc,
			u18.problemPersonal,
			u18.problemPersonalDesc,
			u18.problemScamming,
			u18.problemScammingDesc,
			u18.problemSwearing,
			u18.problemSwearingDesc,
			u18.problemViolence,
			u18.problemViolenceDesc,
			u18.problemIPInfringement,
			u18.problemIPInfringementDesc
		})
		local v22 = React.useMemo(function() -- line: 141
			-- upvalues: u18 (ref)
			return {
				{
					value = "avatar",
					label = u18.surfaceAvatar
				},
				{
					value = "drawing",
					label = u18.surfaceDrawing
				},
				{
					value = "experience",
					label = u18.surfaceExperience
				},
				{
					value = "item",
					label = u18.surfaceItem
				},
				{
					value = "movement",
					label = u18.surfaceMovement
				},
				{
					value = "music",
					label = u18.surfaceMusic
				},
				{
					value = "text",
					label = u18.surfaceTextChat
				},
				{
					value = "username",
					label = u18.surfaceUsername
				}
			}
		end, {
			u18.surfaceAvatar,
			u18.surfaceDrawing,
			u18.surfaceExperience,
			u18.surfaceItem,
			u18.surfaceMovement,
			u18.surfaceMusic,
			u18.surfaceTextChat,
			u18.surfaceUsername
		})
		local v23 = React.useMemo(function() -- line: 163
			-- upvalues: v19 (copy), v22 (copy)
			local v24 = nil

			if v19 ~= nil and v22 ~= nil then
				for i = 1, #v22 do
					local v26 = v22[i]

					if v26 and v26.value == v19 then
						v24 = v26

						return {
							surface = v24
						}
					end
				end
			end

			return {
				surface = v24
			}
		end, {
			v19,
			v22
		})

		return React.createElement(DefaultDualDropdownDialogV2, {
			title = u18.title,
			problems = v21,
			surfaces = v22,
			preselected = v23,
			onClose = t1.onBack,
			onSubmit = t1.onSubmit
		})
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		ZIndex = 10,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5)
	}, {
		SubmitReportDialog = React.createElement(DefaultDualDropdownDialog, {
			analyticsContext = "Test",
			localizationKeys = {
				formTitle = "Feature.ReportAbuse.Title.SelectInSceneFinishYourReport",
				formSubmit = "Feature.ReportAbuse.Action.Submit"
			},
			onSubmitProps = {
				hasNextSteps = true,
				onProceedToNextStep = if not FFlagGenericAbuseReportingGranularExports then t1.onSubmit else function(s1: string, s2: string, s3: string) -- line: 202
					-- upvalues: t1 (copy)
					t1.onSubmit(s1, s2, s3)

					return true
				end
			},
			onCloseProps = {
				hasPreviousSteps = false,
				onAbandon = t1.onBack
			},
			footerContent = function() -- line: 212
				-- upvalues: isShowUKOSAIllegalContentReportingLink (copy), React (copy), View (copy), OSAReportLink (copy)
				if isShowUKOSAIllegalContentReportingLink() then
					return React.createElement(View, {
						tag = "size-full-0 auto-y"
					}, {
						OSALink = React.createElement(OSAReportLink)
					})
				end

				return nil
			end,
			reportProblems = {
				{
					localizationKey = "Feature.ReportAbuse.Problem.Bullying",
					value = "bullying",
					descriptionLocalizationKey = "Feature.ReportAbuse.ProblemDescription.Bullying"
				},
				{
					localizationKey = "Feature.ReportAbuse.Problem.Cheating",
					value = "exploiting",
					descriptionLocalizationKey = "Feature.ReportAbuse.ProblemDescription.Cheating"
				},
				{
					localizationKey = "Feature.ReportAbuse.Problem.Dating",
					value = "dating",
					descriptionLocalizationKey = "Feature.ReportAbuse.ProblemDescription.Dating"
				},
				{
					localizationKey = "Feature.ReportAbuse.Problem.Hate",
					value = "hate",
					descriptionLocalizationKey = "Feature.ReportAbuse.ProblemDescription.Hate"
				},
				{
					localizationKey = "Feature.ReportAbuse.Problem.Links",
					value = "offsite links",
					descriptionLocalizationKey = "Feature.ReportAbuse.ProblemDescription.Links"
				},
				{
					localizationKey = "Feature.ReportAbuse.Problem.Personal",
					value = "personal question",
					descriptionLocalizationKey = "Feature.ReportAbuse.ProblemDescription.Personal"
				},
				{
					localizationKey = "Feature.ReportAbuse.Problem.Scamming",
					value = "scamming",
					descriptionLocalizationKey = "Feature.ReportAbuse.ProblemDescription.Scamming"
				},
				{
					localizationKey = "Feature.ReportAbuse.Problem.Swearing",
					value = "swearing",
					descriptionLocalizationKey = "Feature.ReportAbuse.ProblemDescription.Swearing"
				},
				{
					localizationKey = "Feature.ReportAbuse.Problem.Violence",
					value = "violence",
					descriptionLocalizationKey = "Feature.ReportAbuse.ProblemDescription.Violence"
				}
			},
			reportSurfaces = {
				{
					localizationKey = "Feature.ReportAbuse.ProblemSurface.Avatar",
					value = "avatar"
				},
				{
					localizationKey = "Feature.ReportAbuse.ProblemSurface.DrawingOrCreation",
					value = "drawing"
				},
				{
					localizationKey = "Feature.ReportAbuse.ProblemSurface.Experience",
					value = "experience"
				},
				{
					localizationKey = "Feature.ReportAbuse.ProblemSurface.ItemOrAsset",
					value = "item"
				},
				{
					localizationKey = "Feature.ReportAbuse.ProblemSurface.Movement",
					value = "movement"
				},
				{
					localizationKey = "Feature.ReportAbuse.ProblemSurface.MusicOrSoundEffect",
					value = "music"
				},
				{
					localizationKey = "Feature.ReportAbuse.ProblemSurface.TextChat",
					value = "text"
				},
				{
					localizationKey = "Feature.ReportAbuse.ProblemSurface.Username",
					value = "username"
				}
			}
		})
	})
end

return InGameAssetReportSubmitDialog
