extends Control

@export var linked_chart: NbChart = null
@export var chart_within_node: Node = null
@export var update_interval: float = 0.1

var chart: NbChart = null
var time = 0

func _ready():
	if linked_chart != null:
		chart = linked_chart
	else:
		if chart_within_node == null:
			printerr("NbChartDebugger: No chart to watch is set")
			return
		else:
			for child in chart_within_node.get_children():
				if child is NbChart:
					chart = child
					break
			if chart == null:
				printerr("NbChartDebugger: No chart in child found")
				return
	
	
	update_debugger()


func update_debugger():
	$Tree.clear()
	var root = $Tree.create_item()
	root.set_text(0, chart.name)
	
	for machine in chart.get_children():
		if machine is NbFSM:
			var fsm = $Tree.create_item(root)
			fsm.set_text(0, machine.name)
			
			var current_state = machine.current_state
			var target = machine.timed_target
			for state in machine.get_children():
				if state is NbState:
					var entry_text = state.name
					
					if state == current_state:
						entry_text += " (active)"
					if state == target:
						entry_text += " (soon)"
					
					var entry = $Tree.create_item(fsm)
					entry.set_text(0, entry_text)
	$Log.text = ""
	for entry in chart.history:
		$Log.text += entry + "\n"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if chart != null:
		time += delta
		
		if time >= update_interval:
			update_debugger()
