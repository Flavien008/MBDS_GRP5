import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.StringTokenizer;

import oracle.kv.FaultException;
import oracle.kv.KVStore;
import oracle.kv.KVStoreConfig;
import oracle.kv.KVStoreFactory;
import oracle.kv.StatementResult;
import oracle.kv.table.Row;
import oracle.kv.table.Table;
import oracle.kv.table.TableAPI;

public class Marketing {
    private final KVStore store;

    public static void main(String args[]) {
        try {
            Marketing m = new Marketing(args);
            m.initMarketingTables(m);

        } catch (RuntimeException e) {
            e.printStackTrace();
        }
    }

    Marketing(String[] argv) {

        String storeName = "kvstore";
        String hostName = "localhost";
        String hostPort = "5000";
        final int nArgs = argv.length;
        int argc = 0;

        store = KVStoreFactory.getStore(new KVStoreConfig(storeName, hostName + ":" + hostPort));
    }

    public void initMarketingTables(Marketing arb) {
        arb.dropTableMarketing();
        arb.createTableMarketing();
        arb.lectureMarketingDataFromCSV("/vagrant/MBDS_GRP5/DATA EXTRACTOR/dataSources/Marketing.csv");
    }

    

    public void dropTableMarketing() {
        String statement = null;
        statement = "DROP TABLE MARKETING";
        executeDDL(statement);
    }

    public void createTableMarketing() {
        String statement = null;
        statement = "CREATE TABLE MARKETING ("   
                + "MARKETINGID INTEGER,"           
                + "AGE INTEGER,"
                + "SEXE STRING,"
                + "TAUX INTEGER,"
                + "SITUATION_FAMILIALE STRING,"
                + "NBR_ENFANT INTEGER,"
                + "VOITURE_2 STRING,"
                + "PRIMARY KEY(MARKETINGID))";
        executeDDL(statement);

    }

    public void lectureMarketingDataFromCSV(String marketingDataFileName) {
        String line;
        boolean headerSkipped = false;
    
        System.out.println("Loading Marketing from CSV...");
    
        int id = 1;
        try (BufferedReader br = new BufferedReader(new FileReader(marketingDataFileName))) {
            while ((line = br.readLine()) != null) {
                if (!headerSkipped) {
                    headerSkipped = true;
                    continue;
                }
    
                String[] marketingRecord = line.split(",");
                int age = Integer.parseInt(marketingRecord[0]);
                String sexe = marketingRecord[1];
                int taux = Integer.parseInt(marketingRecord[2]);
                String SFamiliale = marketingRecord[3];
                int nbEnfantsAcharge = Integer.parseInt(marketingRecord[4]);
                String voiture_2 = marketingRecord[5];
                this.insertLineMarketing(id, age, sexe, taux, SFamiliale, nbEnfantsAcharge, voiture_2);
                id++;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    

    private void insertLineMarketing(int marketingid, int age, String sexe, int taux, String SFamiliale, int nbEnfantsAcharge,
            String voiture_2) {
        // TableAPI tableAPI = store.getTableAPI();
        StatementResult result = null;
        String statement = null;
        try {

            TableAPI tableH = store.getTableAPI();
            Table tablemarketing = tableH.getTable("Marketing");

            Row marketingRow = tablemarketing.createRow();

            marketingRow.put("MARKETINGID", marketingid);
            marketingRow.put("AGE", age);
            marketingRow.put("SEXE", sexe);
            marketingRow.put("TAUX", taux);
            marketingRow.put("SITUATION_FAMILIALE", SFamiliale);
            marketingRow.put("NBR_ENFANT", nbEnfantsAcharge);
            marketingRow.put("VOITURE_2", voiture_2);
            tableH.put(marketingRow, null, null);

        } catch (IllegalArgumentException e) {
            System.out.println("Invalid statement:\n" + e.getMessage());
        } catch (FaultException e) {
            System.out.println("Statement couldn't be executed, please retry: " + e);
        }
    }

    public void executeDDL(String statement) {
        TableAPI tableAPI = store.getTableAPI();
        StatementResult result = null;
        try {
            result = store.executeSync(statement);
        } catch (IllegalArgumentException e) {
            System.out.println("Invalid statement:\n" + e.getMessage());
        } catch (FaultException e) {
            System.out.println("Statement couldn't be executed, please retry: " + e);
        }
    }
}

