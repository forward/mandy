module HadoopConfiguration
  def check_home
    hadoop_home = `echo $HADOOP_HOME`.chomp
    if hadoop_home== ''
      puts "You need to set the HADOOP_HOME environment variable to point to your hadoop install    :("
      puts "Try setting 'export HADOOP_HOME=/my/hadoop/path' in your ~/.profile maybe?"
      exit(1)
    end
  end
  
  def check_version
    hadoop_version = `$HADOOP_HOME/bin/hadoop version 2>&1`

    if hadoop_version =~ /No such file or directory/
      puts("Mandy failed to find Hadoop in #{check_home}     :(")
      puts
      puts hadoop_version
      exit(1)
    end
    hadoop_version
  end
end