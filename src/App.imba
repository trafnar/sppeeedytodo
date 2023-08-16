import {nanoid} from "nanoid"
global css body bgc:cooler1

css
	.todo-list d:vflex g:10px
	.todo d:hcl g:5px px:5px h:30px
	.todo .title flg:1
	.todo button s:15px bgc:cooler4 @hover:rose5 rd:full c:white d:vcc fs:9px
	.todo.done .title td:line-through c:gray5 tdc:black/50
	.box bgc:white rd:lg bxs:sm of:hidden
	.new-input px:5px h:30px flg:1 ol:none
	form d:flex
	.blank ta:center c:cooler5 font-style:italic fs:x-small


class Model
	prop todos = [build("Learn Imba"), build("Learn React")]
	def build title do {id:nanoid(), done:false, title}
	def delete todo do todos = todos.filter do(t) t.id !== todo.id
	def toggle todo do update(todo, {done: !todo.done})
	def add title do todos = [...todos, build(title)] if valid(title)
	def rename todo, newTitle do update(todo, {title:newTitle}) if valid(newTitle)
	def valid title do title.trim().length > 0
	def update todo, props do todos = todos.map do(t)
		if todo.id === t.id then {...todo, ...props} else t

const model = new Model

export tag App

	prop newTitle = ""
	def handleSubmit
		model.add(newTitle)
		newTitle = ""

	<self.todo-list>

		<form.box @submit.prevent=handleSubmit>
			<input .new-input type="text" placeholder="new todo..." bind=newTitle>

		if model.todos.length === 0
			<div.blank> "Nothing to do"
		else
			<Todo todo=todo> for todo in model.todos

tag Todo
	prop todo
	prop editing = false
	prop draft = ""
	def setup do draft = todo.title

	def startEdit
		if !editing
			draft = todo.title
			editing = true
			render()
			$input.select()
	
	def commitEdit
		if editing
			model.rename(todo, draft)
			editing = false
	
	def cancelEdit
		if editing
			editing = false

	<self.todo.box .done=todo.done>
		<input type="checkbox" checked=todo.done @change=model.toggle(todo)>
		<div.title>
			if editing
				<form @submit.prevent=commitEdit>
					<input$input type="text" bind=draft
						@hotkey('escape').force.if(editing)=cancelEdit
						@blur=commitEdit
					>
			else
				<span.label @dblclick=startEdit> todo.title
		<button @click=model.delete(todo)> "✕"
