package hu.bme.mit.ttc.refactoring.transformations

import TypeGraphBasic.TypeGraphBasicPackage
import hu.bme.mit.ttc.refactoring.patterns.RefactoringQueries
import org.apache.log4j.Level
import org.eclipse.incquery.runtime.api.AdvancedIncQueryEngine
import org.eclipse.incquery.runtime.evm.api.RuleEngine
import org.eclipse.incquery.runtime.evm.specific.RuleEngines
import org.eclipse.incquery.runtime.evm.specific.event.IncQueryEventRealm
import org.eclipse.viatra.emf.runtime.modelmanipulation.IModelManipulations
import org.eclipse.viatra.emf.runtime.modelmanipulation.SimpleModelManipulations
import org.eclipse.viatra.emf.runtime.rules.batch.BatchTransformationRuleFactory
import org.eclipse.viatra.emf.runtime.rules.batch.BatchTransformationStatements
import org.eclipse.viatra.emf.runtime.transformation.batch.BatchTransformation
import org.eclipse.emf.ecore.util.EcoreUtil
import TypeGraphBasic.TypeGraph

class RefactoringTransformation {
	extension BatchTransformationRuleFactory factory = new BatchTransformationRuleFactory
	extension BatchTransformation transformation
	extension BatchTransformationStatements statements
	extension IModelManipulations manipulation

	extension TypeGraphBasicPackage tgPackage = TypeGraphBasicPackage::eINSTANCE
	extension RefactoringQueries queries = RefactoringQueries::instance
	val AdvancedIncQueryEngine engine

	new(AdvancedIncQueryEngine engine) {
		this(RuleEngines.createIncQueryRuleEngine(engine))
	}

	new(RuleEngine ruleEngine) {
		engine = (ruleEngine.eventRealm as IncQueryEventRealm).engine as AdvancedIncQueryEngine
		transformation = BatchTransformation.forEngine(engine)
		statements = new BatchTransformationStatements(transformation)
		manipulation = new SimpleModelManipulations(iqEngine)
		transformation.ruleEngine.logger.level = Level::DEBUG
	}

	// pull up method

	val pullUpMethodRule = createRule.precondition(pum).action [
		EcoreUtil.delete(definitionN)
		child1.defines -= definition1
		child1.signature -= signature
		childN.signature -= signature

		parent.defines += definition1
		parent.signature += signature
	].build

	val firePullUpMethodRule = createRule.precondition(pum).action [
		fireAllCurrent(pullUpMethodRule)
	].build
	
	
	// create superclass
	
	// case (a)
	
	val createSuperclassARule = createRule.precondition(csA).action [
		println(csA)
		val newSuperclass = typeGraphBasicFactory.createTClass()
		child1.parentClass = newSuperclass
		childN.parentClass = newSuperclass
	].build
	
	val fireCreateSuperclassARule = createRule.precondition(csA).action [
		fireAllCurrent(createSuperclassARule);
	].build
	
	// case (b)
	
	// this should be done in a similar fashion to case (a)
	
	
	def fire() {
//		firePullUpMethodRule.fireOne
//		fireCreateSuperclassARule
	}

}