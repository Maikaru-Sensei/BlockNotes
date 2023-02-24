// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

contract BlockNotes {

    struct Note {
        string noteId;
        string message;
        uint date;
        string location;
    }

    mapping(address => string[]) private blockNotes;
    mapping(string => Note) private noteIdMap;

    function addOrUpdateNote(address _owner, string memory _noteId, string memory _message, uint _date, string memory _location) public {
        noteIdMap[_noteId] = Note(
            _noteId,
            _message,
            _date,
            _location
        );

        if (!isUpdate(_owner, _noteId)) {
            blockNotes[_owner].push(_noteId);
        } 
    }

    function isUpdate(address _owner, string memory _noteId) view private returns(bool) {
        string[] memory notes = blockNotes[_owner];

        for (uint check = 0; check < notes.length; check++) {
            if (keccak256(bytes(notes[check])) == keccak256(bytes(_noteId))) {
                return true;
            }
        }

        return false;
    }

    function getNotes(address _owner) view public returns(Note[] memory) {
        string[] memory noteIds = blockNotes[_owner];

        Note[] memory notes = new Note[](noteIds.length);
        
        for (uint note = 0; note < noteIds.length; note++) {
            notes[note] = noteIdMap[noteIds[note]];
        }

        return notes;
    }
}
