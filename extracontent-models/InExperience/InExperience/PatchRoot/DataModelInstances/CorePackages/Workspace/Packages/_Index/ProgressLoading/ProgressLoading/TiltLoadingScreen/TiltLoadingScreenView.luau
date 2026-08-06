local Parent = script:FindFirstAncestor("ProgressLoading").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local View = Foundation.View
local Progress = Foundation.Progress
local ProgressShape = Foundation.Enums.ProgressShape
local Badge = Foundation.Badge
local IconButton = Foundation.IconButton
local Enums = Foundation.Enums
local useTokens = Foundation.Hooks.useTokens
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local TiltLockup = require(script.Parent.Components.TiltLockup)
local TiltLoadingScreenStatusPanel = require(script.Parent.Components.TiltLoadingScreenStatusPanel)

require(script.Parent.Types)

local function TiltLoadingScreenView(p1) -- line: 22
	-- upvalues: useTokens (copy), useLocalization (copy), React (copy), View (copy), IconButton (copy), Enums (copy), TiltLockup (copy), Badge (copy), TiltLoadingScreenStatusPanel (copy), Progress (copy), ProgressShape (copy)
	local v16 = useTokens()
	local v17 = useLocalization({
		autoTranslate = "CoreScripts.TopBar.LoadingScreen.AutoTranslate"
	})

	return React.createElement(View, {
		tag = "size-full bg-surface-0",
		testId = "tilt-loading-screen-root",
		GroupTransparency = p1.chromeReveal:map(function(n1: number) -- line: 30
			return 1 - n1
		end)
	}, {
		Overlay = React.createElement(View, {
			tag = "size-full",
			ZIndex = 0,
			backgroundStyle = v16.Color.Extended.Black.Black_50
		}),
		CancelButton = React.createElement(View, {
			tag = "col size-full align-x-left align-y-top padding-xlarge",
			ZIndex = 2
		}, {
			Button = React.createElement(IconButton, {
				isCircular = true,
				testId = "tilt-loading-screen-cancel-button",
				icon = Enums.IconName.X,
				variant = Enums.ButtonVariant.Standard,
				size = Enums.InputSize.Large,
				onActivated = p1.onCancel
			})
		}),
		Layout = React.createElement(View, {
			tag = "col size-full",
			ZIndex = 1
		}, {
			Content = React.createElement(View, {
				LayoutOrder = 1,
				tag = "col align-x-center align-y-center grow gap-large size-full-0 padding-x-xxlarge",
				testId = "tilt-loading-screen-lockup-slot"
			}, {
				Lockup = React.createElement(TiltLockup, {
					LayoutOrder = 1,
					gameName = if not p1.gameData then nil else p1.gameData.name,
					creatorName = if not p1.gameData then nil else p1.gameData.creator,
					isCreatorVerified = if not p1.gameData then nil else p1.gameData.verified,
					thumbnailUrl = p1.thumbnailUrl,
					animation = p1.animation
				}),
				AutoTranslate = if not p1.isAutoTranslated then nil else React.createElement(View, {
					LayoutOrder = 2,
					tag = "auto-xy",
					GroupTransparency = p1.animation.creator.reveal:map(function(p2) -- line: 74
						return 1 - p2
					end)
				}, {
					Badge = React.createElement(Badge, {
						text = v17.autoTranslate,
						variant = Enums.BadgeVariant.Neutral,
						shape = Enums.BadgeShape.Box,
						icon = {
							name = Enums.IconName.LanguageCharacters,
							size = Enums.IconSize.XSmall,
							position = Enums.IconPosition.Left
						}
					})
				})
			}),
			StatusPanel = React.createElement(TiltLoadingScreenStatusPanel, {
				LayoutOrder = 3,
				status = p1.statusPanel.status,
				statusText = p1.statusPanel.statusText,
				queuePosition = p1.statusPanel.queuePosition,
				queueTreatment = p1.statusPanel.queueTreatment,
				followUserId = p1.statusPanel.followUserId,
				isSubjectToChinaPolicies = p1.statusPanel.isSubjectToChinaPolicies,
				onAutoJoinNewServer = p1.statusPanel.onAutoJoinNewServer,
				onJoinNewServer = p1.statusPanel.onJoinNewServer,
				onJoinTheLine = p1.statusPanel.onJoinTheLine,
				onShowConnectionHealth = p1.statusPanel.onShowConnectionHealth
			}),
			ProgressBar = if p1.statusPanel.queueTreatment ~= nil then nil else React.createElement(View, {
				LayoutOrder = 4,
				testId = "tilt-loading-screen-progress-slot",
				tag = {
					["size-full-0 auto-y padding-x-medium padding-bottom-xlarge"] = p1.isMobile,
					["size-full-0 auto-y"] = not p1.isMobile
				}
			}, {
				Bar = React.createElement(Progress, {
					testId = "loading-screen-progress-bar",
					shape = ProgressShape.Bar
				})
			})
		})
	})
end

return React.memo(TiltLoadingScreenView)
