alias uptime {
        set chan [channel]
        set text "System uptime: [eval exec uptime]"
   /say $text
   complete
}
