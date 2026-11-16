local InGameAssetReporting = script:FindFirstAncestor("InGameAssetReporting")
local parent = InGameAssetReporting.Parent

local Localization = require(parent.Localization)
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local DsaIllegalContentReporting = require(parent.DsaIllegalContentReporting)
local isShowUKOSAIllegalContentReportingLink = DsaIllegalContentReporting.isShowUKOSAIllegalContentReportingLink
local OSAReportLink = DsaIllegalContentReporting.OSAReportLink

local useLocalization = Localization.Hooks.useLocalization

local DefaultDualDropdownDialog = require(parent.GenericAbuseReporting.DefaultDualDropdownDialog)
local DefaultDualDropdownDialogV2 = require(parent.GenericAbuseReporting.DefaultDualDropdownDialogV2)

local Constants = require(InGameAssetReporting.InGameAssetReportUI.Resources.Constants)
local getPreselectedSurfaceValue = require(InGameAssetReporting.Utility.getPreselectedSurfaceValue)
require(InGameAssetReporting.Analysis.SceneAnalysis)

local SharedFlags = require(parent.SharedFlags)
local FFlagPrefillPreciseSelectionChoices = SharedFlags.FFlagPrefillPreciseSelectionChoices

local SharedFlags2 = require(parent.SharedFlags)
local FFlagGenericAbuseReportingGranularExports = SharedFlags2.FFlagGenericAbuseReportingGranularExports
local SharedFlags3 = require(parent.SharedFlags)
local FFlagDropUnroutableMultiReportOptions = SharedFlags3.FFlagDropUnroutableMultiReportOptions

local function InGameAssetReportSubmitDialog(props)
	local v

	if FFlagPrefillPreciseSelectionChoices then
		v = useLocalization({
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
	else
		v = nil
	end

	if FFlagPrefillPreciseSelectionChoices then
		local preselectedSurfaceValue = getPreselectedSurfaceValue(props.extractionResult)
		local prefilled_surface_selection

		if preselectedSurfaceValue == "avatar" then
			prefilled_surface_selection = v.surfaceAvatar
		elseif preselectedSurfaceValue == "item" then
			prefilled_surface_selection = v.surfaceItem
		elseif preselectedSurfaceValue == "text" then
			prefilled_surface_selection = v.surfaceTextChat
		else
			prefilled_surface_selection = nil
		end

		React.useEffect(function()
			if prefilled_surface_selection then
				props.analyticsDispatch({
					type = Constants.AnalyticsActions.SetPrefilledSurfaceSelection,
					prefilled_surface_selection = prefilled_surface_selection
				})
			end
		end, { prefilled_surface_selection })

		local problems = React.useMemo(function()
			if FFlagDropUnroutableMultiReportOptions then
				return {
					{
						value = "bullying",
						label = v.problemBullying,
						description = v.problemBullyingDesc
					},
					{ value = "dating", label = v.problemDating, description = v.problemDatingDesc },
					{ value = "hate", label = v.problemHate, description = v.problemHateDesc },
					{
						value = "offsite links",
						label = v.problemLinks,
						description = v.problemLinksDesc
					},
					{
						value = "personal question",
						label = v.problemPersonal,
						description = v.problemPersonalDesc
					},
					{
						value = "swearing",
						label = v.problemSwearing,
						description = v.problemSwearingDesc
					},
					{
						value = "violence",
						label = v.problemViolence,
						description = v.problemViolenceDesc
					},
					{
						value = "ip infringement",
						label = v.problemIPInfringement,
						description = v.problemIPInfringementDesc
					}
				}
			end

			return {
				{
					value = "bullying",
					label = v.problemBullying,
					description = v.problemBullyingDesc
				},
				{
					value = "exploiting",
					label = v.problemCheating,
					description = v.problemCheatingDesc
				},
				{ value = "dating", label = v.problemDating, description = v.problemDatingDesc },
				{ value = "hate", label = v.problemHate, description = v.problemHateDesc },
				{
					value = "offsite links",
					label = v.problemLinks,
					description = v.problemLinksDesc
				},
				{
					value = "personal question",
					label = v.problemPersonal,
					description = v.problemPersonalDesc
				},
				{
					value = "scamming",
					label = v.problemScamming,
					description = v.problemScammingDesc
				},
				{
					value = "swearing",
					label = v.problemSwearing,
					description = v.problemSwearingDesc
				},
				{
					value = "violence",
					label = v.problemViolence,
					description = v.problemViolenceDesc
				},
				{
					value = "ip infringement",
					label = v.problemIPInfringement,
					description = v.problemIPInfringementDesc
				}
			}
		end, {
			v.problemBullying,
			v.problemBullyingDesc,
			v.problemCheating,
			v.problemCheatingDesc,
			v.problemDating,
			v.problemDatingDesc,
			v.problemHate,
			v.problemHateDesc,
			v.problemLinks,
			v.problemLinksDesc,
			v.problemPersonal,
			v.problemPersonalDesc,
			v.problemScamming,
			v.problemScammingDesc,
			v.problemSwearing,
			v.problemSwearingDesc,
			v.problemViolence,
			v.problemViolenceDesc,
			v.problemIPInfringement,
			v.problemIPInfringementDesc
		})

		local surfaces = React.useMemo(function()
			if FFlagDropUnroutableMultiReportOptions then
				return {
					{ value = "avatar", label = v.surfaceAvatar },
					{ value = "drawing", label = v.surfaceDrawing },
					{ value = "experience", label = v.surfaceExperience },
					{ value = "item", label = v.surfaceItem },
					{ value = "text", label = v.surfaceTextChat }
				}
			end

			return {
				{ value = "avatar", label = v.surfaceAvatar },
				{ value = "drawing", label = v.surfaceDrawing },
				{ value = "experience", label = v.surfaceExperience },
				{ value = "item", label = v.surfaceItem },
				{ value = "movement", label = v.surfaceMovement },
				{ value = "music", label = v.surfaceMusic },
				{ value = "text", label = v.surfaceTextChat },
				{ value = "username", label = v.surfaceUsername }
			}
		end, {
			v.surfaceAvatar,
			v.surfaceDrawing,
			v.surfaceExperience,
			v.surfaceItem,
			v.surfaceMovement,
			v.surfaceMusic,
			v.surfaceTextChat,
			v.surfaceUsername
		})

		local preselected = React.useMemo(function()
			local surface = nil

			if preselectedSurfaceValue ~= nil and surfaces ~= nil then
				for i = 1, #surfaces do
					local v2 = surfaces[i]

					if v2 and v2.value == preselectedSurfaceValue then
						surface = v2
						break
					end
				end
			end

			return { surface = surface }
		end, { preselectedSurfaceValue, surfaces })

		return React.createElement(DefaultDualDropdownDialogV2, {
			title = v.title,
			problems = problems,
			surfaces = surfaces,
			preselected = preselected,
			onClose = props.onBack,
			onSubmit = props.onSubmit
		})
	end

	return React.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		ZIndex = 10
	}, {
		SubmitReportDialog = React.createElement(DefaultDualDropdownDialog, {
			analyticsContext = "Test",
			localizationKeys = {
				formTitle = "Feature.ReportAbuse.Title.SelectInSceneFinishYourReport",
				formSubmit = "Feature.ReportAbuse.Label.Report"
			},
			onSubmitProps = {
				hasNextSteps = true,
				onProceedToNextStep = FFlagGenericAbuseReportingGranularExports and function(p: string, p2: string, p3: string): boolean
					props.onSubmit(p, p2, p3)
					return true
				end or props.onSubmit
			},
			onCloseProps = { hasPreviousSteps = false, onAbandon = props.onBack },
			footerContent = function()
				if isShowUKOSAIllegalContentReportingLink() then
					return React.createElement(View, { tag = "size-full-0 auto-y" }, {
						OSALink = React.createElement(OSAReportLink)
					})
				end

				return nil
			end,
			reportProblems = FFlagDropUnroutableMultiReportOptions and {
				{
					localizationKey = "Feature.ReportAbuse.Problem.Bullying",
					value = "bullying",
					descriptionLocalizationKey = "Feature.ReportAbuse.ProblemDescription.Bullying"
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
					localizationKey = "Feature.ReportAbuse.Problem.Swearing",
					value = "swearing",
					descriptionLocalizationKey = "Feature.ReportAbuse.ProblemDescription.Swearing"
				},
				{
					localizationKey = "Feature.ReportAbuse.Problem.Violence",
					value = "violence",
					descriptionLocalizationKey = "Feature.ReportAbuse.ProblemDescription.Violence"
				}
			} or {
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
			reportSurfaces = FFlagDropUnroutableMultiReportOptions and {
				{ localizationKey = "Feature.ReportAbuse.ProblemSurface.Avatar", value = "avatar" },
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
				{ localizationKey = "Feature.ReportAbuse.ProblemSurface.TextChat", value = "text" }
			} or {
				{ localizationKey = "Feature.ReportAbuse.ProblemSurface.Avatar", value = "avatar" },
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
				{ localizationKey = "Feature.ReportAbuse.ProblemSurface.TextChat", value = "text" },
				{
					localizationKey = "Feature.ReportAbuse.ProblemSurface.Username",
					value = "username"
				}
			}
		})
	})
end

return InGameAssetReportSubmitDialog
