# functionality for running tests
class_name Test
extends RefCounted

const indent: String = "	"

var _category: String

func _init(category: String) -> void:
	self._category = category

var tests: Array[Callable]

func add(test: Callable) -> Test:
	tests.append(test)
	return self
	
func run() -> void:
	var print_buff: Array[String]
	var success: int = 0
	for test in tests:
		var passed: bool = test.call()
		var status: String
		if passed == false: 
			status = "[color=red]FAILED[/color]"
		else: 
			status = "[color=green]PASSED[/color]"
			success += 1
		
		var line: String = indent + status + ": " + test.get_method()
		
		if not passed:
			push_error("TEST FAILED: from [%s] called [%s]" % [_category, test.get_method()])
		print_buff.append(line)
		
	var all_passed: bool = success == tests.size()
	var color: String
	
	color = "green" if all_passed else "red"
	
	print_rich("[color=cyan]Testing:[/color] %s [color=%s](%d/%d)[/color] tests passed" % [_category, color, success, tests.size()])
	for line in print_buff:
		print_rich(line)
	#if not all_passed:
		# push_error("At least one test in %s failed, check testing ouput for details" % _category)
