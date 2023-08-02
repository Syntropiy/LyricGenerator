public class Archive{
  String archiveName = "Lyrical_Archive";
  public Archive(){  
  }
  
  //Create archive directory if none exists - returns false if created, true if existing
  public File makeDirectory(String path){
    path+="\\" + archiveName;
    File archDir = new File(path);
    Path tempath = Paths.get(path);
    //if the directory already exists
    if(Files.exists(tempath)){
      println("Archive directory already exists!");
      return archDir;
    } else if(archDir.mkdir()) {
      println("Archive directory created");
      return archDir;
    }
    println("Archive doesn't exist, but failed to be created!");
    println("Exiting program...");
    exit();
    return archDir;
  }
  
  public Boolean fileTransfer(File f, String path){
    try{
      File pathFileTemp = new File(path);
      Path archDir = Paths.get(f.getAbsolutePath() + "\\" + pathFileTemp.getName());
      Path textFile = Paths.get(path);
      Files.copy(textFile, archDir, StandardCopyOption.REPLACE_EXISTING);
    
      if(Files.exists(archDir)){
        File orig = textFile.toFile();
        File copi = archDir.toFile();
        String[] original = loadStrings(orig);
        String[] copied = loadStrings(copi);
        if(copied.length == original.length){
          for(int i = 0; i < original.length; i++){
            if(!original[i].equals(copied[i])){
              println("Archival failed, archived file contents not equal to original!");
              return false;
            }
          }
        } else {
          println("Archival failed, archived file different length to original!");
          return false;
        }
      } else {
        println("Archival failed, original file not copied!");
      }  
      println("Successfully copied file!");
      return true;
    } catch (IOException io){
      println("Archival failed");
      return false;
    }
  }
}
