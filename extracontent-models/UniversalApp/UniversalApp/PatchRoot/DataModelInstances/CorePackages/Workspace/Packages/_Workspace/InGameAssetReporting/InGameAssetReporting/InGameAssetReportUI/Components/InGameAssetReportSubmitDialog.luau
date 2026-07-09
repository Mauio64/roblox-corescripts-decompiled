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
local FFlagReportIPInfringement = require(InGameAssetReportingParent.SharedFlags).FFlagReportIPInfringement
local FFlagGenericAbuseReportingGranularExports = require(InGameAssetReportingParent.SharedFlags).FFlagGenericAbuseReportingGranularExports

local function InGameAssetReportSubmitDialog(t1: {[any]: any}) -- line: 37
	-- upvalues: FFlagPrefillPreciseSelectionChoices (copy), useLocalization (copy), getPreselectedSurfaceValue (copy), React (copy), Constants (copy), FFlagReportIPInfringement (copy), DefaultDualDropdownDialogV2 (copy), DefaultDualDropdownDialog (copy), FFlagGenericAbuseReportingGranularExports (copy), isShowUKOSAIllegalContentReportingLink (copy), View (copy), OSAReportLink (copy)
	local u19 = nil

	if FFlagPrefillPreciseSelectionChoices then
		u19 = useLocalization({
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
		local v20 = getPreselectedSurfaceValue(t1.extractionResult)
		local v21 = if v20 ~= "avatar" then if v20 ~= "item" then if v20 ~= "text" then nil else u19.surfaceTextChat else u19.surfaceItem else u19.surfaceAvatar

		React.useEffect(function() -- line: 81
			-- upvalues: v21 (copy), t1 (copy), Constants (copy)
			if v21 then
				t1.analyticsDispatch({
					type = Constants.AnalyticsActions.SetPrefilledSurfaceSelection,
					prefilled_surface_selection = v21
				})
			end
		end, { v21 })

		local v22 = React.useMemo(function() -- line: 90
			-- upvalues: u19 (ref), FFlagReportIPInfringement (copy)
			return {
				{
					value = "bullying",
					label = u19.problemBullying,
					description = u19.problemBullyingDesc
				},
				{
					value = "exploiting",
					label = u19.problemCheating,
					description = u19.problemCheatingDesc
				},
				{
					value = "dating",
					label = u19.problemDating,
					description = u19.problemDatingDesc
				},
				{
					value = "hate",
					label = u19.problemHate,
					description = u19.problemHateDesc
				},
				{
					value = "offsite links",
					label = u19.problemLinks,
					description = u19.problemLinksDesc
				},
				{
					value = "personal question",
					label = u19.problemPersonal,
					description = u19.problemPersonalDesc
				},
				{
					value = "scamming",
					label = u19.problemScamming,
					description = u19.problemScammingDesc
				},
				{
					value = "swearing",
					label = u19.problemSwearing,
					description = u19.problemSwearingDesc
				},
				{
					value = "violence",
					label = u19.problemViolence,
					description = u19.problemViolenceDesc
				},
				if not FFlagReportIPInfringement then nil else {
					value = "ip infringement",
					label = u19.problemIPInfringement,
					description = u19.problemIPInfringementDesc
				}
			}
		end, {
			u19.problemBullying,
			u19.problemBullyingDesc,
			u19.problemCheating,
			u19.problemCheatingDesc,
			u19.problemDating,
			u19.problemDatingDesc,
			u19.problemHate,
			u19.problemHateDesc,
			u19.problemLinks,
			u19.problemLinksDesc,
			u19.problemPersonal,
			u19.problemPersonalDesc,
			u19.problemScamming,
			u19.problemScammingDesc,
			u19.problemSwearing,
			u19.problemSwearingDesc,
			u19.problemViolence,
			u19.problemViolenceDesc,
			u19.problemIPInfringement,
			u19.problemIPInfringementDesc
		})
		local v23 = React.useMemo(function() -- line: 144
			-- upvalues: u19 (ref)
			return {
				{
					value = "avatar",
					label = u19.surfaceAvatar
				},
				{
					value = "drawing",
					label = u19.surfaceDrawing
				},
				{
					value = "experience",
					label = u19.surfaceExperience
				},
				{
					value = "item",
					label = u19.surfaceItem
				},
				{
					value = "movement",
					label = u19.surfaceMovement
				},
				{
					value = "music",
					label = u19.surfaceMusic
				},
				{
					value = "text",
					label = u19.surfaceTextChat
				},
				{
					value = "username",
					label = u19.surfaceUsername
				}
			}
		end, {
			u19.surfaceAvatar,
			u19.surfaceDrawing,
			u19.surfaceExperience,
			u19.surfaceItem,
			u19.surfaceMovement,
			u19.surfaceMusic,
			u19.surfaceTextChat,
			u19.surfaceUsername
		})
		local v24 = React.useMemo(function() -- line: 166
			-- upvalues: v20 (copy), v23 (copy)
			local v25 = nil

			if v20 ~= nil and v23 ~= nil then
				for i = 1, #v23 do
					local v27 = v23[i]

					if v27 and v27.value == v20 then
						v25 = v27

						return {
							surface = v25
						}
					end
				end
			end

			return {
				surface = v25
			}
		end, {
			v20,
			v23
		})

		return React.createElement(DefaultDualDropdownDialogV2, {
			title = u19.title,
			problems = v22,
			surfaces = v23,
			preselected = v24,
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
				onProceedToNextStep = if not FFlagGenericAbuseReportingGranularExports then t1.onSubmit else function(s1: string, s2: string, s3: string) -- line: 205
					-- upvalues: t1 (copy)
					t1.onSubmit(s1, s2, s3)

					return true
				end
			},
			onCloseProps = {
				hasPreviousSteps = false,
				onAbandon = t1.onBack
			},
			footerContent = function() -- line: 215
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
