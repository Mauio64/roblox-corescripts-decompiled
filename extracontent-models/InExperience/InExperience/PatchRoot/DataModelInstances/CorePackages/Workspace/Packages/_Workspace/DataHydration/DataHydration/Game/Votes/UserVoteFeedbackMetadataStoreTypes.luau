local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent

require(DataHydration.DataHydrationTypes)
require(DataHydrationParent.Signals)

local t = require(DataHydrationParent.t)

return {
	userVoteFeedbackMetadataResponseValidator = t.interface({
		capabilities = t.interface({
			can_submit_review = t.boolean,
			can_submit_category_options = t.optional(t.boolean),
			can_submit_comment = t.boolean
		}),
		categories = t.array(t.interface({
			type = t.string,
			label = t.string,
			allows_multiple_selections = t.boolean,
			options = t.array(t.interface({
				id = t.string,
				label = t.string
			}))
		})),
		comment = t.interface({
			label = t.string,
			placeholder_text = t.string,
			minimum_length = t.number,
			maximum_length = t.number
		}),
		metadata = t.interface({
			disclaimer_label = t.string,
			submit_button_label = t.string,
			form_title_label = t.string
		})
	})
}
