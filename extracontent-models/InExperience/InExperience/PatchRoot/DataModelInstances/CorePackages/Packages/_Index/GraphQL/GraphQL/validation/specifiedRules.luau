local rules = script.Parent.rules
local ExecutableDefinitionsRule = require(rules.ExecutableDefinitionsRule).ExecutableDefinitionsRule
local UniqueOperationNamesRule = require(rules.UniqueOperationNamesRule).UniqueOperationNamesRule
local LoneAnonymousOperationRule = require(rules.LoneAnonymousOperationRule).LoneAnonymousOperationRule
local SingleFieldSubscriptionsRule = require(rules.SingleFieldSubscriptionsRule).SingleFieldSubscriptionsRule
local KnownTypeNamesRule = require(rules.KnownTypeNamesRule).KnownTypeNamesRule
local FragmentsOnCompositeTypesRule = require(rules.FragmentsOnCompositeTypesRule).FragmentsOnCompositeTypesRule
local VariablesAreInputTypesRule = require(rules.VariablesAreInputTypesRule).VariablesAreInputTypesRule
local ScalarLeafsRule = require(rules.ScalarLeafsRule).ScalarLeafsRule
local FieldsOnCorrectTypeRule = require(rules.FieldsOnCorrectTypeRule).FieldsOnCorrectTypeRule
local UniqueFragmentNamesRule = require(rules.UniqueFragmentNamesRule).UniqueFragmentNamesRule
local KnownFragmentNamesRule = require(rules.KnownFragmentNamesRule).KnownFragmentNamesRule
local NoUnusedFragmentsRule = require(rules.NoUnusedFragmentsRule).NoUnusedFragmentsRule
local PossibleFragmentSpreadsRule = require(rules.PossibleFragmentSpreadsRule).PossibleFragmentSpreadsRule
local NoFragmentCyclesRule = require(rules.NoFragmentCyclesRule).NoFragmentCyclesRule
local UniqueVariableNamesRule = require(rules.UniqueVariableNamesRule).UniqueVariableNamesRule
local NoUndefinedVariablesRule = require(rules.NoUndefinedVariablesRule).NoUndefinedVariablesRule
local NoUnusedVariablesRule = require(rules.NoUnusedVariablesRule).NoUnusedVariablesRule
local KnownDirectivesRule = require(rules.KnownDirectivesRule).KnownDirectivesRule
local UniqueDirectivesPerLocationRule = require(rules.UniqueDirectivesPerLocationRule).UniqueDirectivesPerLocationRule
local KnownArgumentNamesRule = require(rules.KnownArgumentNamesRule)
local KnownArgumentNamesRule2 = KnownArgumentNamesRule.KnownArgumentNamesRule
local KnownArgumentNamesOnDirectivesRule = KnownArgumentNamesRule.KnownArgumentNamesOnDirectivesRule
local UniqueArgumentNamesRule = require(rules.UniqueArgumentNamesRule).UniqueArgumentNamesRule
local ValuesOfCorrectTypeRule = require(rules.ValuesOfCorrectTypeRule).ValuesOfCorrectTypeRule
local ProvidedRequiredArgumentsRule = require(rules.ProvidedRequiredArgumentsRule)
local ProvidedRequiredArgumentsRule2 = ProvidedRequiredArgumentsRule.ProvidedRequiredArgumentsRule
local ProvidedRequiredArgumentsOnDirectivesRule = ProvidedRequiredArgumentsRule.ProvidedRequiredArgumentsOnDirectivesRule
local VariablesInAllowedPositionRule = require(rules.VariablesInAllowedPositionRule).VariablesInAllowedPositionRule
local OverlappingFieldsCanBeMergedRule = require(rules.OverlappingFieldsCanBeMergedRule).OverlappingFieldsCanBeMergedRule
local UniqueInputFieldNamesRule = require(rules.UniqueInputFieldNamesRule).UniqueInputFieldNamesRule
local LoneSchemaDefinitionRule = require(rules.LoneSchemaDefinitionRule).LoneSchemaDefinitionRule
local UniqueOperationTypesRule = require(rules.UniqueOperationTypesRule).UniqueOperationTypesRule
local UniqueTypeNamesRule = require(rules.UniqueTypeNamesRule).UniqueTypeNamesRule
local UniqueEnumValueNamesRule = require(rules.UniqueEnumValueNamesRule).UniqueEnumValueNamesRule
local UniqueFieldDefinitionNamesRule = require(rules.UniqueFieldDefinitionNamesRule).UniqueFieldDefinitionNamesRule
local UniqueDirectiveNamesRule = require(rules.UniqueDirectiveNamesRule).UniqueDirectiveNamesRule
local PossibleTypeExtensionsRule = require(rules.PossibleTypeExtensionsRule).PossibleTypeExtensionsRule

return {
	specifiedRules = {
		ExecutableDefinitionsRule,
		UniqueOperationNamesRule,
		LoneAnonymousOperationRule,
		SingleFieldSubscriptionsRule,
		KnownTypeNamesRule,
		FragmentsOnCompositeTypesRule,
		VariablesAreInputTypesRule,
		ScalarLeafsRule,
		FieldsOnCorrectTypeRule,
		UniqueFragmentNamesRule,
		KnownFragmentNamesRule,
		NoUnusedFragmentsRule,
		PossibleFragmentSpreadsRule,
		NoFragmentCyclesRule,
		UniqueVariableNamesRule,
		NoUndefinedVariablesRule,
		NoUnusedVariablesRule,
		KnownDirectivesRule,
		UniqueDirectivesPerLocationRule,
		KnownArgumentNamesRule2,
		UniqueArgumentNamesRule,
		ValuesOfCorrectTypeRule,
		ProvidedRequiredArgumentsRule2,
		VariablesInAllowedPositionRule,
		OverlappingFieldsCanBeMergedRule,
		UniqueInputFieldNamesRule
	},
	specifiedSDLRules = {
		LoneSchemaDefinitionRule,
		UniqueOperationTypesRule,
		UniqueTypeNamesRule,
		UniqueEnumValueNamesRule,
		UniqueFieldDefinitionNamesRule,
		UniqueDirectiveNamesRule,
		KnownTypeNamesRule,
		KnownDirectivesRule,
		UniqueDirectivesPerLocationRule,
		PossibleTypeExtensionsRule,
		KnownArgumentNamesOnDirectivesRule,
		UniqueArgumentNamesRule,
		UniqueInputFieldNamesRule,
		ProvidedRequiredArgumentsOnDirectivesRule
	}
}
