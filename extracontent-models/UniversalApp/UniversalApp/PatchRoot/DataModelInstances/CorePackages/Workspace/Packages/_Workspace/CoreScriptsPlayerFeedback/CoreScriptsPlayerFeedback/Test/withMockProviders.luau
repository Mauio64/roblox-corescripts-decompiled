local ParentParent = script.Parent.Parent.Parent
local React = require(ParentParent.React)
local LocalizationProvider = require(ParentParent.Localization).LocalizationProvider
local UnitTestHelpers = require(ParentParent.Dev.UnitTestHelpers)
local t1 = {
	BackButton = "Back",
	Send = "Send",
	Title = "How can the creator help?",
	["ReportAbuse.Lead"] = "Trying to report abuse?",
	["ReportAbuse.Link"] = "<u>Submit a report instead.</u>",
	["Category.Label"] = "Category *",
	["Category.Placeholder"] = "Select a category",
	["Category.BugReport"] = "Bug report",
	["Category.DataRestoreRequest"] = "Item or data restoration",
	["Category.PurchasingIssue"] = "Purchase issue",
	["Category.Other"] = "Other",
	["Description.Label"] = "Details *",
	["Description.CharacterLimitHint"] = "Up to {MAX} characters",
	["Placeholder.BugReport"] = "BugReport placeholder",
	["Placeholder.DataRestoreRequest"] = "DataRestoreRequest placeholder",
	["Placeholder.PurchasingIssue"] = "PurchasingIssue placeholder",
	["Placeholder.Other"] = "Other placeholder",
	["ShareUserId.Label"] = "Share user information with creator",
	["ShareUserId.LabelRequired"] = "Share user information with creator (required)",
	["ShareUserId.Hint"] = "This helps the creator support the correct account.",
	["Toast.Submitted"] = "Support request sent",
	["Toast.Failed"] = "We couldn't send your request. Please try again later.",
	["Unavailable.Default.Title"] = "Support unavailable",
	["Unavailable.Default.Body"] = "Player support is currently unavailable. Please try again later.",
	["Unavailable.Under13.Title"] = "Feature not available",
	["Unavailable.Under13.Body"] = "Player support requests are unavailable for users under 13.",
	["Unavailable.NotRecentlyVisited.Title"] = "Visit required",
	["Unavailable.NotRecentlyVisited.Body"] = "You need to have played this experience recently to file a support request.",
	["Unavailable.OpenTicketLimit.Title"] = "Request already open",
	["Unavailable.OpenTicketLimit.Body"] = "Please wait for the creator to respond to your existing requests before submitting another request.",
	["Unavailable.RateLimited.Title"] = "Try again later",
	["Unavailable.RateLimited.Body"] = "Player support is temporarily unavailable. Please try again in a few minutes.",
	["Unavailable.TextFilter.Title"] = "Submission failed",
	["Unavailable.TextFilter.Body"] = "Your submission violated Roblox Community Standards. Trying to report abuse?"
}

local function withMockProviders(p1) -- line: 49
	-- upvalues: t1 (copy), React (copy), LocalizationProvider (copy), UnitTestHelpers (copy)
	local t2 = {
		Format = function(_, p3, p4) -- line: 51
			-- upvalues: t1 (copy)
			if string.sub(p3, 1, 47) == "CoreScripts.FeedbackPrompt.PlayerSupportPrompt." then
				local v12 = t1[string.sub(p3, 48)] or p3

				if p4 then
					for k, v in pairs(p4) do
						v12 = string.gsub(v12, "{" .. k .. "}", (tostring(v)))
					end
				end

				return v12
			end

			local v15 = string.gsub(p3, "CoreScripts%.FeedbackPrompt%.FeedbackPrompt%.", "")

			if string.find(v15, "^Unavailable%.") then
				if v15 == "Unavailable.Title" then
					return "UnavailableTitle"
				end

				if v15 == "Unavailable.Header.Under13" then
					return "Under13Title"
				end

				if v15 == "Unavailable.Hint.Under13" then
					return "Under13Content"
				end

				if v15 == "Unavailable.Header.RateLimited" then
					return "RateLimitedTitle"
				end

				if v15 == "Unavailable.Hint.RateLimited" then
					return "RateLimitedContent"
				end

				if v15 == "Unavailable.Header.Default" then
					return "DefaultTitle"
				end

				if v15 == "Unavailable.Hint.Default" then
					return "DefaultContent"
				end

				if v15 == "Unavailable.OkayButton" then
					return "OK"
				end
			else
				if v15 == "Title" then
					return "Feedback Prompt"
				end

				if v15 == "Submit" then
					return "Submit"
				end

				if v15 == "Submitting" then
					return "Submitting..."
				end

				if v15 == "Placeholder" then
					return "Enter your feedback here..."
				end

				if v15 == "Intro" then
					return "Tell us about your experience"
				end

				if v15 == "Footer" then
					return "Your feedback helps improve the experience"
				end

				if v15 == "Error.TooShort" then
					return "Feedback too short"
				end

				if v15 == "Error.TooLong" then
					return "Feedback too long"
				end
			end

			if p4 then
				for k, v in pairs(p4) do
					v15 = string.gsub(v15, "{" .. k .. "}", (tostring(v)))
				end
			end

			return v15
		end
	}

	return React.createElement(LocalizationProvider, {
		localization = t2
	}, {
		StyleProvider = UnitTestHelpers.createStyleProvider({
			App = p1
		})
	})
end

return withMockProviders
