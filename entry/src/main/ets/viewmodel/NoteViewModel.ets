import { NoteCategory, NoteModel } from '../model/Note'

@Observed
export class NoteViewModel {
  notes: NoteModel[] = [
    new NoteModel('欢迎使用鸿蒙记事本', '支持快速记录、分类管理、置顶与归档。', NoteCategory.WORK, 'seed-1', Date.now() - 1800000, true, false),
    new NoteModel('周末采购清单', '牛奶、面包、水果、咖啡豆', NoteCategory.LIFE, 'seed-2', Date.now() - 86400000, false, false),
    new NoteModel('产品灵感', 'AI 总结 + 手写草图识别 + 跨设备流转', NoteCategory.IDEA, 'seed-3', Date.now() - 3600000, false, false)
  ]
  keyword: string = ''
  selectedCategory: NoteCategory = NoteCategory.ALL
  showArchived: boolean = false

  createNote(title: string, content: string, category: NoteCategory): void {
    const trimmedTitle: string = title.trim()
    const trimmedContent: string = content.trim()
    if (!trimmedTitle && !trimmedContent) {
      return
    }
    const nextTitle: string = trimmedTitle || '无标题'
    const nextContent: string = trimmedContent || '暂无内容'
    this.notes.unshift(new NoteModel(nextTitle, nextContent, category))
  }

  updateNote(noteId: string, title: string, content: string, category: NoteCategory): void {
    const index: number = this.notes.findIndex((item: NoteModel) => item.id === noteId)
    if (index < 0) {
      return
    }
    this.notes[index].title = title.trim() || '无标题'
    this.notes[index].content = content.trim() || '暂无内容'
    this.notes[index].category = category
    this.notes[index].updatedAt = Date.now()
    this.notes = [...this.notes]
  }

  togglePin(noteId: string): void {
    const target: NoteModel | undefined = this.notes.find((item: NoteModel) => item.id === noteId)
    if (!target) {
      return
    }
    target.isPinned = !target.isPinned
    target.updatedAt = Date.now()
    this.notes = [...this.notes]
  }

  toggleArchive(noteId: string): void {
    const target: NoteModel | undefined = this.notes.find((item: NoteModel) => item.id === noteId)
    if (!target) {
      return
    }
    target.isArchived = !target.isArchived
    target.updatedAt = Date.now()
    this.notes = [...this.notes]
  }

  deleteNote(noteId: string): void {
    this.notes = this.notes.filter((item: NoteModel) => item.id !== noteId)
  }

  filteredNotes(): NoteModel[] {
    const normalizedKeyword: string = this.keyword.trim().toLowerCase()
    const list: NoteModel[] = this.notes.filter((item: NoteModel) => {
      const inArchiveScope: boolean = item.isArchived === this.showArchived
      const inCategoryScope: boolean = this.selectedCategory === NoteCategory.ALL || item.category === this.selectedCategory
      const inKeywordScope: boolean = !normalizedKeyword ||
        item.title.toLowerCase().includes(normalizedKeyword) ||
        item.content.toLowerCase().includes(normalizedKeyword)
      return inArchiveScope && inCategoryScope && inKeywordScope
    })

    return list.sort((prev: NoteModel, next: NoteModel) => {
      if (prev.isPinned !== next.isPinned) {
        return prev.isPinned ? -1 : 1
      }
      return next.updatedAt - prev.updatedAt
    })
  }
}
