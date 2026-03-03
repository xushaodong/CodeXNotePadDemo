export enum NoteCategory {
  ALL = '全部',
  WORK = '工作',
  LIFE = '生活',
  IDEA = '灵感'
}

export class NoteModel {
  id: string
  title: string
  content: string
  category: NoteCategory
  updatedAt: number
  isPinned: boolean
  isArchived: boolean

  constructor(
    title: string,
    content: string,
    category: NoteCategory = NoteCategory.LIFE,
    id: string = `note-${Date.now()}-${Math.floor(Math.random() * 10000)}`,
    updatedAt: number = Date.now(),
    isPinned: boolean = false,
    isArchived: boolean = false
  ) {
    this.id = id
    this.title = title
    this.content = content
    this.category = category
    this.updatedAt = updatedAt
    this.isPinned = isPinned
    this.isArchived = isArchived
  }
}

export function formatNoteTime(timestamp: number): string {
  const date: Date = new Date(timestamp)
  const now: Date = new Date()
  const isSameDay: boolean = date.getFullYear() === now.getFullYear() &&
    date.getMonth() === now.getMonth() &&
    date.getDate() === now.getDate()

  if (isSameDay) {
    return `${String(date.getHours()).padStart(2, '0')}:${String(date.getMinutes()).padStart(2, '0')}`
  }

  return `${date.getMonth() + 1}月${date.getDate()}日`
}
