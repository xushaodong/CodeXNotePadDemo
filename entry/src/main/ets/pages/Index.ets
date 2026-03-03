import { formatNoteTime, NoteCategory, NoteModel } from '../model/Note'
import { NoteViewModel } from '../viewmodel/NoteViewModel'

@Entry
@Component
struct Index {
  @State private viewModel: NoteViewModel = new NoteViewModel()
  @State private showEditor: boolean = false
  @State private editingId: string = ''
  @State private inputTitle: string = ''
  @State private inputContent: string = ''
  @State private inputCategory: NoteCategory = NoteCategory.LIFE

  private categories: NoteCategory[] = [NoteCategory.ALL, NoteCategory.WORK, NoteCategory.LIFE, NoteCategory.IDEA]

  private openEditor(note?: NoteModel): void {
    if (note) {
      this.editingId = note.id
      this.inputTitle = note.title
      this.inputContent = note.content
      this.inputCategory = note.category
    } else {
      this.editingId = ''
      this.inputTitle = ''
      this.inputContent = ''
      this.inputCategory = NoteCategory.LIFE
    }
    this.showEditor = true
  }

  private saveEditor(): void {
    if (this.editingId) {
      this.viewModel.updateNote(this.editingId, this.inputTitle, this.inputContent, this.inputCategory)
    } else {
      this.viewModel.createNote(this.inputTitle, this.inputContent, this.inputCategory)
    }
    this.showEditor = false
  }

  @Builder
  private CategoryChip(category: NoteCategory) {
    const isSelected: boolean = this.viewModel.selectedCategory === category
    Text(category)
      .fontSize(14)
      .fontWeight(isSelected ? FontWeight.Bold : FontWeight.Regular)
      .fontColor(isSelected ? '#0A59F7' : '#3D4656')
      .padding({ left: 14, right: 14, top: 8, bottom: 8 })
      .backgroundColor(isSelected ? '#E7F0FF' : '#F3F5F7')
      .borderRadius(16)
      .onClick(() => {
        this.viewModel.selectedCategory = category
      })
  }

  @Builder
  private NoteCard(note: NoteModel) {
    Column({ space: 10 }) {
      Row() {
        Text(note.title)
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor('#1F2633')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        Blank()
        if (note.isPinned) {
          Text('置顶')
            .fontSize(12)
            .fontColor('#0A59F7')
            .padding({ left: 8, right: 8, top: 4, bottom: 4 })
            .backgroundColor('#EAF2FF')
            .borderRadius(10)
        }
      }
      .width('100%')

      Text(note.content)
        .fontSize(14)
        .fontColor('#5B6473')
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })

      Row({ space: 8 }) {
        Text(note.category)
          .fontSize(12)
          .fontColor('#3D4656')
          .padding({ left: 8, right: 8, top: 4, bottom: 4 })
          .backgroundColor('#F3F5F7')
          .borderRadius(10)
        Text(formatNoteTime(note.updatedAt))
          .fontSize(12)
          .fontColor('#8A93A5')
        Blank()
        Button(note.isPinned ? '取消置顶' : '置顶')
          .type(ButtonType.Capsule)
          .fontSize(12)
          .height(28)
          .backgroundColor('#EAF2FF')
          .fontColor('#0A59F7')
          .onClick(() => this.viewModel.togglePin(note.id))
      }
      .width('100%')

      Row({ space: 8 }) {
        Button('编辑')
          .layoutWeight(1)
          .height(34)
          .onClick(() => this.openEditor(note))
        Button(note.isArchived ? '取消归档' : '归档')
          .layoutWeight(1)
          .height(34)
          .backgroundColor('#F3F5F7')
          .fontColor('#3D4656')
          .onClick(() => this.viewModel.toggleArchive(note.id))
        Button('删除')
          .layoutWeight(1)
          .height(34)
          .backgroundColor('#FFEDEF')
          .fontColor('#D23A45')
          .onClick(() => this.viewModel.deleteNote(note.id))
      }
      .width('100%')
    }
    .padding(16)
    .margin({ bottom: 12 })
    .backgroundColor('#FFFFFF')
    .borderRadius(16)
  }

  build() {
    Stack({ alignContent: Alignment.BottomEnd }) {
      Column({ space: 14 }) {
        Text('鸿蒙记事本')
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .width('100%')
          .textAlign(TextAlign.Start)

        TextInput({ placeholder: '搜索标题或正文', text: $$this.viewModel.keyword })
          .height(44)
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .fontSize(15)

        Scroll({ scrollBar: BarState.Off, scrollable: true }) {
          Row({ space: 10 }) {
            ForEach(this.categories, (category: NoteCategory) => {
              this.CategoryChip(category)
            }, (category: NoteCategory) => category)
          }
        }
        .width('100%')

        Row({ space: 8 }) {
          Button(this.viewModel.showArchived ? '查看普通笔记' : '查看归档笔记')
            .type(ButtonType.Capsule)
            .backgroundColor('#F3F5F7')
            .fontColor('#3D4656')
            .onClick(() => {
              this.viewModel.showArchived = !this.viewModel.showArchived
            })
        }
        .width('100%')

        List({ space: 0 }) {
          ForEach(this.viewModel.filteredNotes(), (note: NoteModel) => {
            ListItem() {
              this.NoteCard(note)
            }
            .editable(false)
          }, (note: NoteModel) => note.id)
        }
        .layoutWeight(1)
        .width('100%')
        .divider({ strokeWidth: 0 })
      }
      .height('100%')
      .width('100%')
      .padding({ left: 16, right: 16, top: 22, bottom: 90 })
      .backgroundColor('#F7F8FA')

      Button('+')
        .width(56)
        .height(56)
        .margin({ right: 20, bottom: 24 })
        .borderRadius(28)
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .backgroundColor('#0A59F7')
        .fontColor('#FFFFFF')
        .onClick(() => this.openEditor())
    }
    .bindSheet($$this.showEditor, this.EditorSheet(), {
      height: 0.75,
      dragBar: true,
      detents: [SheetSize.FIT_CONTENT, SheetSize.LARGE]
    })
  }

  @Builder
  private EditorSheet() {
    Column({ space: 14 }) {
      Text(this.editingId ? '编辑笔记' : '新建笔记')
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .width('100%')

      TextInput({ placeholder: '标题', text: $$this.inputTitle })
        .height(44)
        .backgroundColor('#F3F5F7')
        .borderRadius(10)

      TextArea({ placeholder: '输入内容...', text: $$this.inputContent })
        .height(180)
        .backgroundColor('#F3F5F7')
        .borderRadius(10)

      Row({ space: 8 }) {
        ForEach([NoteCategory.WORK, NoteCategory.LIFE, NoteCategory.IDEA], (category: NoteCategory) => {
          const selected: boolean = this.inputCategory === category
          Text(category)
            .fontSize(13)
            .fontWeight(selected ? FontWeight.Medium : FontWeight.Regular)
            .fontColor(selected ? '#0A59F7' : '#3D4656')
            .padding({ left: 12, right: 12, top: 7, bottom: 7 })
            .backgroundColor(selected ? '#EAF2FF' : '#F3F5F7')
            .borderRadius(12)
            .onClick(() => {
              this.inputCategory = category
            })
        }, (category: NoteCategory) => category)
      }
      .width('100%')

      Row({ space: 10 }) {
        Button('取消')
          .layoutWeight(1)
          .height(42)
          .backgroundColor('#F3F5F7')
          .fontColor('#3D4656')
          .onClick(() => {
            this.showEditor = false
          })
        Button('保存')
          .layoutWeight(1)
          .height(42)
          .backgroundColor('#0A59F7')
          .fontColor('#FFFFFF')
          .onClick(() => this.saveEditor())
      }
      .width('100%')
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
  }
}
