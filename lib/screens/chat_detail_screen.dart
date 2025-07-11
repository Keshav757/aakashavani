import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatDetailScreen extends StatefulWidget {
  final String userId; // receiver ID
  final String userName;
  final String userImage;
  final String userPhone;

  const ChatDetailScreen({
    super.key,
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.userPhone,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;

  String _getChatId(String uid1, String uid2) {
    return uid1.compareTo(uid2) < 0 ? '$uid1\_$uid2' : '$uid2\_$uid1';
  }

  void _sendMessage() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final text = _messageController.text.trim();
    if (text.isEmpty || currentUser == null) return;

    final chatId = _getChatId(currentUser.uid, widget.userId);
    final timestamp = FieldValue.serverTimestamp();

    await FirebaseFirestore.instance
      .collection('chats')
      .doc(chatId)
      .collection('messages')
      .add({
        'text': text,
        'senderId': currentUser.uid,
        'receiverId': widget.userId,
        'timestamp': timestamp,
        'isRead': false,
      });

    _messageController.clear();
  }


  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text("User not logged in")),
      );
    }

    final chatId = _getChatId(currentUser.uid, widget.userId);

      return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: widget.userImage.isNotEmpty
                  ? NetworkImage(widget.userImage)
                  : null,
              child: widget.userImage.isEmpty ? const Icon(Icons.person) : null,
            ),
            const SizedBox(width: 10),
            Text(widget.userName),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(chatId)
                  .collection('messages')
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;

                // Mark received messages as read
                for (var msg in messages) {
                  final data = msg.data() as Map<String, dynamic>?;
                  if (data == null) continue;

                  final isMe = data['senderId'] == currentUser.uid;
                  final isForMe = data['receiverId'] == currentUser.uid;
                  final isRead = data.containsKey('isRead') ? data['isRead'] : false;

                  if (isForMe && !isRead) {
                    msg.reference.update({'isRead': true});
                  }
                }



                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg['senderId'] == currentUser.uid;
                    final timestamp = msg['timestamp'] as Timestamp?;
                    final time = timestamp != null
                        ? TimeOfDay.fromDateTime(timestamp.toDate()).format(context)
                        : '';

                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(10),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7,
                        ),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.green[100] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment:
                              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            Text(
                              msg['text'],
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              time,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            color: Colors.grey[100],
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: "Type a message",
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => _sendMessage(),
                    textInputAction: TextInputAction.send,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.green),
                  onPressed: _sendMessage,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

// default $targetEntity1;
// default $targetEntity2;
// move 'ACCOUNT' to $targetEntity1;
// move 'CASE' to $targetEntity2;
// move 'CHAR TYPE' to $charTypeMo;
// move 'F1-MSTCFG' to $masterConfigMo;

// // Retrieve Soft Parameter
// move "string(parm/soft[1]/value)" to $charType;
// move "string(parm/soft[2]/value)" to $perCharMasterConfigBO;
// move "string(parm/soft[3]/value)" to $provinceMasterConfigBO;

// // Retrieve Hard Parameter
// move "string(parm/hard/entityId/PKValue1)" to $personId;

// //if charType is invalid, throw error
// if("$charType != $BLANK")
//     move null to "F1-DoesEntityExist";
//     move "$charTypeMo" to "F1-DoesEntityExist/mo";
//     move "$charType" to "F1-DoesEntityExist/pkValue1";
//     invokeBS 'F1-DoesEntityExist' using "F1-DoesEntityExist";     
//     if ("string(F1-DoesEntityExist/entityExists) = 'false'")
//         terminate with error(90040, 11006 %1= "$charType");
//     end-if; 
// end-if;

// //if Person char Master Config is invalid, throw error
// if("$perCharMasterConfigBO != $BLANK")
//     move null to "F1-DoesEntityExist";
//     move "$masterConfigMo" to "F1-DoesEntityExist/mo";
//     move "$perCharMasterConfigBO" to "F1-DoesEntityExist/pkValue1";
//     invokeBS 'F1-DoesEntityExist' using "F1-DoesEntityExist";     
//     if ("string(F1-DoesEntityExist/entityExists) = 'false'")
//         terminate with error(90040, 11007 %1= "$perCharMasterConfigBO");
//     end-if; 
// end-if;

// //if Province Master Config is invalid, throw error
// if("$provinceMasterConfigBO != $BLANK")
//     move null to "F1-DoesEntityExist";
//     move "$masterConfigMo" to "F1-DoesEntityExist/mo";
//     move "$provinceMasterConfigBO" to "F1-DoesEntityExist/pkValue1";
//     invokeBS 'F1-DoesEntityExist' using "F1-DoesEntityExist";     
//     if ("string(F1-DoesEntityExist/entityExists) = 'false'")
//         terminate with error(90040, 11007 %1= "$provinceMasterConfigBO");
//     end-if; 
// end-if;

// // Read Master Config BO
// declareBO "$perCharMasterConfigBO" as 'perCharMasterConfigBO';
// move "$perCharMasterConfigBO" to "perCharMasterConfigBO/bo";
// invokeBO "$perCharMasterConfigBO" using "perCharMasterConfigBO" for read;

// // Read province master config BO
// declareBO "$provinceMasterConfigBO" as 'provinceMasterConfigBO';
// move "$provinceMasterConfigBO" to "provinceMasterConfigBO/bo";
// invokeBO "$provinceMasterConfigBO" using "provinceMasterConfigBO" for read;

// // Get Source Char Value
// move null to "CM-PERCHAR";
// move "$personId" to "CM-PERCHAR/personId";
// move "$charType" to "CM-PERCHAR/characteristicType";
// move "$CURRENT-DATE" to "CM-PERCHAR/effectiveDate";
// invokeBS 'CM-PERCHAR' using "CM-PERCHAR";
// if ("CM-PERCHAR/rowCount > 0")
//      move "string(CM-PERCHAR/results/characteristicValue)" to $sourceCharVal;
// else
//      terminate with error(90040, 11003 %1="$charType");
// end-if;

// // if the user Id is available in the userList then do not perform validation with target entities
// if("count(provinceMasterConfigBO/userGrp/userList[user=$USER]) > 0")
//   goto 999;
// end-if;

// // Get Account linked to person
// move null to "CM-RETACCPER";
// move "$personId" to "CM-RETACCPER/personId";
// invokeBS 'CM-RETACCPER' using "CM-RETACCPER";

// if ("CM-RETACCPER/rowCount > 0")
// 	for ($accountIdList in "CM-RETACCPER/results")
//         // Get Target Char Value
//         move null to "CM-ACCTCHARVALS";
//         move "string($accountIdList/accountId)" to "CM-ACCTCHARVALS/acctId";
//         move "$charType" to "CM-ACCTCHARVALS/charType";
//         move "$CURRENT-DATE" to "CM-ACCTCHARVALS/effectiveDate";
//         invokeBS 'CM-ACCTCHARVALS' using "CM-ACCTCHARVALS";
//         if ("CM-ACCTCHARVALS/rowCount > 0")
//              move "string(CM-ACCTCHARVALS/results/charVal)" to $targetCharVal1;

// 			// Get Outcome from Master Configuration
// 			move "string(perCharMasterConfigBO/provinceCharMatrixGrp/provinceEntityList[targetEntity = $targetEntity1]/provinceCharMatrixList[soureCharValue =$sourceCharVal and targetCharValue = $targetCharVal1]/outcome)" to $outcome1;
//             move "string(perCharMasterConfigBO/provinceCharMatrixGrp/provinceEntityList[targetEntity = $targetEntity1]/provinceCharMatrixList[soureCharValue =$sourceCharVal and targetCharValue = $targetCharVal1]/msgCategory)" to          $msgCategory;
//             move "string(perCharMasterConfigBO/provinceCharMatrixGrp/provinceEntityList[targetEntity = $targetEntity1]/provinceCharMatrixList[soureCharValue =$sourceCharVal and targetCharValue = $targetCharVal1]/msgNumber)" to $msgNumber;
            
// 			// If outcome = 'E'throw error
//            if ("$outcome1 = 'E'")

//                move null to "F1-RethrowError";
//                move "$msgCategory" to "F1-RethrowError/messageCategory";
//                move "$msgNumber" to "F1-RethrowError/messageNumber";
//                move "$sourceCharVal" to "F1-RethrowError/messageParameters/+parameters/parameterValue";
//                move "$targetEntity1" to "F1-RethrowError/messageParameters/+parameters/parameterValue";
//                move "$targetCharVal1" to "F1-RethrowError/messageParameters/+parameters/parameterValue";
//                invokeBS 'F1-RethrowError' using "F1-RethrowError";
//            end-if;
//         else
//         	terminate with error(90040, 11005 %1="$charType" %2="$targetEntity1");
//         end-if;		
//     end-for;    
// end-if;

// Get Case linked to person
// move null to "CM-RETCASPER";
// move "$personId" to "CM-RETCASPER/personId";
// invokeBS 'CM-RETCASPER' using "CM-RETCASPER";

// if ("CM-RETCASPER/rowCount > 0")
  
// 	for ($caseIdList in "CM-RETCASPER/results")     
//         // Get Target Char Value
//         move null to "CM-CASECHAR";
//         move "string($caseIdList/caseId)" to "CM-CASECHAR/caseId";
//         move "$charType" to "CM-CASECHAR/characteristicType";
//         invokeBS 'CM-CASECHAR' using "CM-CASECHAR";

//         if ("CM-CASECHAR/rowCount > 0")
//         	move "string(CM-CASECHAR/results/characteristicValue)" to $targetCharVal2;

// 			// Get Outcome from Master Configuration
// 			move "string(perCharMasterConfigBO/provinceCharMatrixGrp/provinceEntityList[targetEntity = $targetEntity2]/provinceCharMatrixList[soureCharValue =$sourceCharVal and targetCharValue = $targetCharVal2]/outcome)" to $outcome2;
//  			move "string(perCharMasterConfigBO/provinceCharMatrixGrp/provinceEntityList[targetEntity = $targetEntity2]/provinceCharMatrixList[soureCharValue =$sourceCharVal and targetCharValue = $targetCharVal2]/msgCategory)" to $msgCategory;
//             move "string(perCharMasterConfigBO/provinceCharMatrixGrp/provinceEntityList[targetEntity = $targetEntity2]/provinceCharMatrixList[soureCharValue =$sourceCharVal and targetCharValue = $targetCharVal2]/msgNumber)" to $msgNumber;
            
// 			// If outcome = 'E' throw error
//            if ("$outcome2 = 'E'")
//                move null to "F1-RethrowError";
//                move "$msgCategory" to "F1-RethrowError/messageCategory";
//                move "$msgNumber" to "F1-RethrowError/messageNumber";
//                move "$sourceCharVal" to "F1-RethrowError/messageParameters/+parameters/parameterValue";
//                move "$targetEntity2" to "F1-RethrowError/messageParameters/+parameters/parameterValue";
//                move "$targetCharVal2" to "F1-RethrowError/messageParameters/+parameters/parameterValue";
//                invokeBS 'F1-RethrowError' using "F1-RethrowError";
//            end-if;
//         else
//         	terminate with error(90040, 11005 %1="$charType" %2="$targetEntity2");
//         end-if;
//     end-for;    
// end-if;
