# 개요
할일 관리를 위한 ToDo 앱.
다중 개발 프로젝트 관리. 자료 저장 기능.
data 파일은 `/Users/deliciouscat/MemomoData`에서 관리하도록 함.

# 기능
## 프로젝트 관리

```UI Pseudo Code
VerticalGrid(
    HorizontalGrid(     // Menu Bar
        [
            IconButton(➕, desc: "add new task/memo"),
            IconButton(📝 or 🛞, desc: "switch main sheet to memo sheet/task sheet"),
            IconButton(🔎, desc: "search content from memo sheet/task sheet"),
            ActivationCircle(desc: "Green(#29E578) if apps in WorkAppList is Activated frontmost. Red(#ED3755) if not")
            ActivationGauge(desc: "Bar gauge. via 'gauge decrease rate' and 'gauge increase rate'. "),
            ActivationMaxDuration(desc: "How long was the gauge was max status. h m s notation. ")
            IconButton(⚙️, desc: "Modal page for setting. Activation: [max gauge(point), increase(point/s), decrease(point/s), WorkAppList]")
        ]
    ),
    TaskSheet
)

TaskSheet = HorizontalGrid(
    [RenderTaskAbstract(task) for task in TaskCardsList], // task card 선택 -> selectedTask
    VerticalGrid(
        [RenderSubtaskDetails(subTask) for subTask in selectedTask if subTask.checkbox==False],
        Dropdown(
            [RenderSubtaskAbstract(subTask) for subTask in selectedTask if subTask.checkbox==True]
        )
    )
).switchIf{clickIcon(📝), to: MemoSheet}

MemoSheet = HorizontalGrid(
    [TextBox(memo.name) for memo in MemoList],
    MarkdownEditor(memo.content)    // Editable, Markdown render.
).switchIf{clickIcon(🛞), to: TaskSheet}
```

### Task Card
- 시작날짜 기록.
- 자료 링크 저장.
- 체크박스가 있는 Sub Task. 해치운 일들은 Drop Box에서 확인 가능.
```Task Card
Props{
    name: str,
    startDate: datetime,
    endDate: none or datetime,
    subTasks: List[SubTask]
}

def RenderTaskAbstract{
    desc: "name, start date, num of completed tasks, activation statistics"
}
```

```SubTask
Props{
    name: str,
    describtion: str,
    startDate: datetime
    endDate: none or datetime,  // if checkbox is checked
    checkBox: boolean
}

def RenderSubtaskDetails{
    desc: "checkbox, name, describtion... etc. editable."
}

def RenderSubtaskAbstract{
    desc: "checkbox, name, duration"
}
```


# 개발 스택
- Swift
- Swift UI
- NSWorkspace