require 'rake'

# Configs that live under ~/.config/ rather than as ~/.dotfile, keyed by their
# path in this repo. The :symlink convention below only covers ~/.<name>, so
# XDG-style targets are listed explicitly. Add a line per new app.
XDG_LINKS = {
  'ghostty/config' => '.config/ghostty/config',
  # Only config is tracked; the rest of ~/.claude* is session state.
  'claude-code/settings.json' => '.claude/settings.json',
  'claude-code/settings-personal.json' => '.claude-personal/settings.json',
  'claude-code/hooks/no-emdash-semicolon.py' => '.claude/hooks/no-emdash-semicolon.py',
}

desc "Symlink XDG-style configs (~/.config/...) into place."
task :install_config do
  XDG_LINKS.each do |source, relative_target|
    source_path = File.expand_path(source, __dir__)
    target = File.join(ENV['HOME'], relative_target)

    unless File.exist?(source_path)
      puts "Missing source, skipping: #{source}"
      next
    end

    # Already pointing where we want it.
    next if File.symlink?(target) && File.readlink(target) == source_path

    FileUtils.mkdir_p(File.dirname(target))

    if File.symlink?(target)
      puts "Repointing stale symlink: #{target}"
      File.unlink(target)
    elsif File.exist?(target)
      backup = "#{target}.backup"
      puts "Backing up #{target} -> #{backup}"
      FileUtils.mv(target, backup)
    end

    File.symlink(source_path, target)
    puts "Linked #{relative_target} -> #{source}"
  end
end

desc "Hook our dotfiles into system-standard positions."
task :install => :install_config do
  linkables = Dir.glob('*/**{.symlink}')

  skip_all = false
  overwrite_all = false
  backup_all = false

  linkables.each do |linkable|
    overwrite = false
    backup = false

    file = linkable.split('/').last.split('.symlink').last
    target = "#{ENV["HOME"]}/.#{file}"

    if File.exists?(target) || File.symlink?(target)
      unless skip_all || overwrite_all || backup_all
        puts "File already exists: #{target}, what do you want to do? [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all"
        case STDIN.gets.chomp
        when 'o' then overwrite = true
        when 'b' then backup = true
        when 'O' then overwrite_all = true
        when 'B' then backup_all = true
        when 'S' then skip_all = true
        when 's' then next
        end
      end
      FileUtils.rm_rf(target) if overwrite || overwrite_all
      `mv "$HOME/.#{file}" "$HOME/.#{file}.backup"` if backup || backup_all
    end
    `ln -s "$PWD/#{linkable}" "#{target}"`
  end
end

task :uninstall do

  XDG_LINKS.each do |source, relative_target|
    target = File.join(ENV['HOME'], relative_target)
    File.unlink(target) if File.symlink?(target)
    FileUtils.mv("#{target}.backup", target) if File.exist?("#{target}.backup")
  end

  Dir.glob('**/*.symlink').each do |linkable|

    file = linkable.split('/').last.split('.symlink').last
    target = "#{ENV["HOME"]}/.#{file}"

    # Remove all symlinks created during installation
    if File.symlink?(target)
      FileUtils.rm(target)
    end
    
    # Replace any backups made during installation
    if File.exists?("#{ENV["HOME"]}/.#{file}.backup")
      `mv "$HOME/.#{file}.backup" "$HOME/.#{file}"` 
    end

  end
end

task :default => 'install'
